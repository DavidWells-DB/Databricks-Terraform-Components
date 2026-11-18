locals {
  vnet_parts          = split("/", var.existing_vnet_id)
  resource_group_name = local.vnet_parts[4]
  vnet_name           = local.vnet_parts[8]
}

data "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  resource_group_name = local.resource_group_name
}

data "azurerm_subnet" "host" {
  name                 = element(split("/", var.existing_host_subnet_id), length(split("/", var.existing_host_subnet_id)) - 1)
  virtual_network_name = local.vnet_name
  resource_group_name  = local.resource_group_name
}

data "azurerm_subnet" "container" {
  name                 = element(split("/", var.existing_container_subnet_id), length(split("/", var.existing_container_subnet_id)) - 1)
  virtual_network_name = local.vnet_name
  resource_group_name  = local.resource_group_name
}
