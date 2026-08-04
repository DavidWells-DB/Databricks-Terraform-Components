###############################################################################
# Managed Security Component
# VNet injection with Secure Cluster Connectivity (No Public IP / NPIP)
###############################################################################

module "vnet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-vnet?ref=azure-account-network-vnet/v0.2.0"

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
