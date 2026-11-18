###############################################################################
# GCP BYOVPC Networking Component
# Composes: VPC + Cloud NAT for egress
###############################################################################

locals {
  network_name = var.network_name != "" ? var.network_name : "${var.resource_prefix}-vpc"
}

module "vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-vpc?ref=gcp-account-network-vpc/v0.1.3"

  providers = {
    databricks.account = databricks.account
  }

  project_id                   = var.project_id
  region                       = var.region
  resource_prefix              = var.resource_prefix
  databricks_account_id        = var.databricks_account_id
  network_name                 = local.network_name
  vpc_name                     = var.network_name != "" ? var.network_name : null
  network_cidr                 = var.network_cidr
  pod_secondary_range_cidr     = var.pod_secondary_range_cidr
  service_secondary_range_cidr = var.service_secondary_range_cidr
  subnetwork_name              = var.subnetwork_name
  pod_secondary_range_name     = var.pod_secondary_range_name
  service_secondary_range_name = var.service_secondary_range_name
  firewall_rule_name           = var.firewall_rule_name
}

module "cloud_nat" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-cloud-nat?ref=gcp-account-network-cloud-nat/v0.1.1"

  project_id           = var.project_id
  region               = var.region
  network_self_link    = module.vpc.network_self_link
  subnetwork_self_link = module.vpc.subnetwork_self_link
  resource_prefix      = var.resource_prefix
  router_name          = var.router_name
  nat_name             = var.nat_name
  min_ports_per_vm     = var.min_ports_per_vm
  log_config_enable    = var.log_config_enable
  log_config_filter    = var.log_config_filter
}
