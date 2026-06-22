###############################################################################
# Hardened Connectivity Component
# VNet injection + back-end Private Link (no front-end PE)
###############################################################################

module "vnet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-vnet?ref=main"

  resource_group_name   = var.resource_group_name
  location              = var.location
  vnet_name             = var.vnet_name
  vnet_cidr             = var.vnet_cidr
  host_subnet_name      = var.host_subnet_name
  host_subnet_cidr      = var.host_subnet_cidr
  container_subnet_name = var.container_subnet_name
  container_subnet_cidr = var.container_subnet_cidr
  pe_subnet_name        = var.pe_subnet_name
  pe_subnet_cidr        = var.pe_subnet_cidr
  nsg_name              = var.nsg_name
  tags                  = var.tags
}

module "private_endpoints" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-private-endpoints?ref=main"

  resource_group_name    = var.resource_group_name
  location               = var.location
  workspace_resource_id  = var.workspace_resource_id
  pe_subnet_id           = module.vnet.pe_subnet_id
  vnet_id                = module.vnet.vnet_id
  enable_front_end_pe    = false
  enable_browser_auth_pe = false
  tags                   = var.tags
}
