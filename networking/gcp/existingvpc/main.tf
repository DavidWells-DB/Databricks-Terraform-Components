locals {
  network_parts    = split("/", var.existing_network_self_link)
  subnetwork_parts = split("/", var.existing_subnetwork_self_link)
}

data "google_compute_network" "this" {
  name    = local.network_parts[9]
  project = local.network_parts[6]
}

data "google_compute_subnetwork" "this" {
  name    = local.subnetwork_parts[10]
  region  = local.subnetwork_parts[8]
  project = local.subnetwork_parts[6]

  lifecycle {
    postcondition {
      condition     = self.network == var.existing_network_self_link
      error_message = "The existing subnetwork must belong to existing_network_self_link."
    }
  }
}

resource "databricks_mws_networks" "this" {
  provider = databricks.account

  account_id   = var.databricks_account_id
  network_name = coalesce(var.network_registration_name, data.google_compute_network.this.name)

  gcp_network_info {
    network_project_id = local.network_parts[6]
    vpc_id             = data.google_compute_network.this.name
    subnet_id          = data.google_compute_subnetwork.this.name
    subnet_region      = data.google_compute_subnetwork.this.region
  }
}
