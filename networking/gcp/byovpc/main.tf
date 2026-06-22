###############################################################################
# GCP BYOVPC Networking Component
# Composes: VPC + Cloud NAT for egress
###############################################################################

locals {
  network_name = var.network_name != "" ? var.network_name : "${var.resource_prefix}-vpc"
}

module "vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-vpc?ref=main"

  providers = {
    databricks.account = databricks.account
  }

  project_id                   = var.project_id
  region                       = var.region
  resource_prefix              = var.resource_prefix
  databricks_account_id        = var.databricks_account_id
  network_name                 = local.network_name
  network_cidr                 = var.network_cidr
  pod_secondary_range_cidr     = var.pod_secondary_range_cidr
  service_secondary_range_cidr = var.service_secondary_range_cidr
}

module "cloud_nat" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-cloud-nat?ref=main"

  project_id         = var.project_id
  region             = var.region
  network_self_link  = module.vpc.network_self_link
  subnetwork_self_link = module.vpc.subnetwork_self_link
  resource_prefix    = var.resource_prefix
}
