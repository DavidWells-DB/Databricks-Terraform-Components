###############################################################################
# Multi-Workspace PrivateLink Networking Component
# Composes: VPC + Egress Internet + VPC Endpoints + PrivateLink Endpoints
#
# Single shared VPC with backend PrivateLink (REST + Relay) that can be
# shared across multiple Databricks workspaces.
###############################################################################

locals {
  private_access_settings_name = var.private_access_settings_name != "" ? var.private_access_settings_name : "${var.resource_prefix}-pas"
  workspace_vpc_endpoint_name  = var.workspace_vpc_endpoint_name != "" ? var.workspace_vpc_endpoint_name : "${var.resource_prefix}-workspace-ep"
  relay_vpc_endpoint_name      = var.relay_vpc_endpoint_name != "" ? var.relay_vpc_endpoint_name : "${var.resource_prefix}-relay-ep"
  security_group_name          = var.security_group_name != "" ? var.security_group_name : "${var.resource_prefix}-privatelink-sg"

  security_group_ingress_cidr_blocks = length(var.security_group_ingress_cidr_blocks) > 0 ? var.security_group_ingress_cidr_blocks : [var.vpc_cidr]
}

module "vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-vpc?ref=main"

  providers = {
    databricks.account = databricks.account
  }

  databricks_account_id    = var.databricks_account_id
  resource_prefix          = var.resource_prefix
  network_name             = "${var.resource_prefix}-network"
  vpc_cidr                 = var.vpc_cidr
  azs                      = var.availability_zones
  private_subnet_cidrs     = var.private_subnet_cidrs
  public_subnet_cidrs      = var.public_subnet_cidrs
  privatelink_subnet_cidrs = var.privatelink_subnet_cidrs
  databricks_gov_shard     = var.databricks_gov_shard
  tags                     = var.tags
}

module "egress_internet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-egress-internet?ref=main"

  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = values(module.vpc.public_subnet_ids)
  private_route_table_ids = values(module.vpc.private_route_table_ids)
  tags                    = var.tags
}

module "vpc_endpoints" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-vpc-endpoints?ref=main"

  vpc_id                  = module.vpc.vpc_id
  region                  = var.region
  private_subnet_ids      = values(module.vpc.private_subnet_ids)
  security_group_ids      = [module.vpc.security_group_id]
  private_route_table_ids = values(module.vpc.private_route_table_ids)
  databricks_gov_shard    = var.databricks_gov_shard
  tags                    = var.tags
}

module "privatelink_endpoints" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-privatelink-endpoints?ref=main"

  providers = {
    databricks.account = databricks.account
  }

  vpc_id                             = module.vpc.vpc_id
  privatelink_subnet_ids             = values(module.vpc.privatelink_subnet_ids)
  region                             = var.region
  private_access_settings_name       = local.private_access_settings_name
  workspace_vpc_endpoint_name        = local.workspace_vpc_endpoint_name
  relay_vpc_endpoint_name            = local.relay_vpc_endpoint_name
  security_group_name                = local.security_group_name
  security_group_ingress_cidr_blocks = local.security_group_ingress_cidr_blocks
  databricks_gov_shard               = var.databricks_gov_shard
  tags                               = var.tags
}
