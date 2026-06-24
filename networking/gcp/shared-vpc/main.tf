###############################################################################
# GCP Shared VPC Networking Component
# Composes: VPC (host project) + Cloud NAT + Shared VPC host/service binding
###############################################################################

locals {
  network_name = var.network_name != "" ? var.network_name : "${var.resource_prefix}-vpc"
}

###############################################################################
# VPC — created in the host project
###############################################################################

module "vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-vpc?ref=gcp-account-network-vpc/v0.1.0"

  providers = {
    databricks.account = databricks.account
  }

  project_id                   = var.host_project_id
  region                       = var.region
  resource_prefix              = var.resource_prefix
  databricks_account_id        = var.databricks_account_id
  network_name                 = local.network_name
  network_cidr                 = var.network_cidr
  pod_secondary_range_cidr     = var.pod_secondary_range_cidr
  service_secondary_range_cidr = var.service_secondary_range_cidr
}

###############################################################################
# Cloud NAT — egress for workspace nodes
###############################################################################

module "cloud_nat" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-cloud-nat?ref=gcp-account-network-cloud-nat/v0.1.0"

  project_id           = var.host_project_id
  region               = var.region
  network_self_link    = module.vpc.network_self_link
  subnetwork_self_link = module.vpc.subnetwork_self_link
  resource_prefix      = var.resource_prefix
}

###############################################################################
# Shared VPC — host/service project association
###############################################################################

module "shared_vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-shared-vpc?ref=gcp-account-network-shared-vpc/v0.1.0"

  host_project_id     = var.host_project_id
  service_project_ids = var.service_project_ids
}
