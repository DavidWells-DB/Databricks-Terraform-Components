###############################################################################
# GCP PSC Exfiltration Protection Component
# Composes: Spoke VPC (module) + Hub VPC (inline) + PSC Endpoints (module)
#           + Firewall deny-all egress + VPC Peering
###############################################################################

###############################################################################
# Spoke VPC — Databricks workspace network
###############################################################################

module "spoke_vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-vpc?ref=gcp-account-network-vpc/v0.1.0"

  providers = {
    databricks.account = databricks.account
  }

  project_id                   = var.project_id
  region                       = var.region
  resource_prefix              = "${var.resource_prefix}-spoke"
  databricks_account_id        = var.databricks_account_id
  network_name                 = "${var.resource_prefix}-spoke-vpc"
  network_cidr                 = var.spoke_network_cidr
  pod_secondary_range_cidr     = var.pod_secondary_range_cidr
  service_secondary_range_cidr = var.service_secondary_range_cidr
}

###############################################################################
# Hub VPC — hosts PSC endpoints and firewall rules
###############################################################################

resource "google_compute_network" "hub" {
  project                 = var.project_id
  name                    = "${var.resource_prefix}-hub-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "hub" {
  project       = var.project_id
  name          = "${var.resource_prefix}-hub-subnet"
  ip_cidr_range = var.hub_network_cidr
  region        = var.region
  network       = google_compute_network.hub.id
}

resource "google_compute_subnetwork" "psc" {
  project       = var.project_id
  name          = "${var.resource_prefix}-psc-subnet"
  ip_cidr_range = var.psc_subnet_cidr
  region        = var.region
  network       = google_compute_network.hub.id
  purpose       = "PRIVATE_SERVICE_CONNECT"
}

###############################################################################
# VPC Peering — Hub <-> Spoke
###############################################################################

resource "google_compute_network_peering" "hub_to_spoke" {
  name                 = "${var.resource_prefix}-hub-to-spoke"
  network              = google_compute_network.hub.id
  peer_network         = module.spoke_vpc.network_self_link
  export_custom_routes = true
  import_custom_routes = false
}

resource "google_compute_network_peering" "spoke_to_hub" {
  name                 = "${var.resource_prefix}-spoke-to-hub"
  network              = module.spoke_vpc.network_self_link
  peer_network         = google_compute_network.hub.id
  export_custom_routes = false
  import_custom_routes = true

  depends_on = [google_compute_network_peering.hub_to_spoke]
}

###############################################################################
# Firewall Rules — Deny-all egress + selective allow
###############################################################################

resource "google_compute_firewall" "deny_all_egress" {
  project   = var.project_id
  name      = "${var.resource_prefix}-deny-all-egress"
  network   = google_compute_network.hub.id
  direction = "EGRESS"
  priority  = 65534

  deny {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_google_apis" {
  project   = var.project_id
  name      = "${var.resource_prefix}-allow-google-apis"
  network   = google_compute_network.hub.id
  direction = "EGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = [var.google_apis_cidr]
}

resource "google_compute_firewall" "allow_psc_endpoints" {
  project   = var.project_id
  name      = "${var.resource_prefix}-allow-psc"
  network   = google_compute_network.hub.id
  direction = "EGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = [var.psc_subnet_cidr]
}

resource "google_compute_firewall" "allow_intra_vpc" {
  project   = var.project_id
  name      = "${var.resource_prefix}-allow-intra-vpc"
  network   = google_compute_network.hub.id
  direction = "EGRESS"
  priority  = 1000

  allow {
    protocol = "all"
  }

  destination_ranges = [var.hub_network_cidr, var.spoke_network_cidr]
}

###############################################################################
# PSC Endpoints — Private connectivity to Databricks control plane
###############################################################################

module "psc_endpoints" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-psc-endpoints?ref=gcp-account-network-psc-endpoints/v0.1.0"

  providers = {
    databricks.account = databricks.account
  }

  databricks_account_id = var.databricks_account_id
  project_id            = var.project_id
  region                = var.region
  network_self_link     = google_compute_network.hub.self_link
  psc_subnet_self_link  = google_compute_subnetwork.psc.self_link
  resource_prefix       = var.resource_prefix
  public_access_enabled = var.public_access_enabled

  depends_on = [
    google_compute_network_peering.hub_to_spoke,
    google_compute_network_peering.spoke_to_hub,
  ]
}
