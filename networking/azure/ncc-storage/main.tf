###############################################################################
# NCC + Storage Component
# Network Connectivity Config (serverless) + VNet (classic compute)
#
# Both halves are independently toggleable: a serverless-only deployment can
# disable the VNet (enable_vnet = false), and a classic-only deployment can
# disable the NCC (enable_ncc = false). Both default to enabled.
###############################################################################

###############################################################################
# Network Connectivity Config (for Serverless Compute)
###############################################################################

module "ncc" {
  count  = var.enable_ncc ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-connectivity-config?ref=main"

  providers = {
    databricks.account = databricks.account
  }

  databricks_account_id = var.databricks_account_id
  name                  = var.ncc_name
  region                = var.ncc_region
}

###############################################################################
# VNet (for Classic Compute)
###############################################################################

module "vnet" {
  count  = var.enable_vnet ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-vnet?ref=main"

  resource_group_name   = var.resource_group_name
  location              = var.location
  vnet_name             = var.vnet_name
  vnet_cidr             = var.vnet_cidr
  host_subnet_name      = var.host_subnet_name
  host_subnet_cidr      = var.host_subnet_cidr
  container_subnet_name = var.container_subnet_name
  container_subnet_cidr = var.container_subnet_cidr
  nsg_name              = var.nsg_name
  tags                  = var.tags
}
