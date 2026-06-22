###############################################################################
# Hub-Spoke Firewall Component
# Hub-Spoke topology with Azure Firewall (without Private Link)
###############################################################################

###############################################################################
# Hub VNet — raw resources (AzureFirewallSubnet and GatewaySubnet cannot have NSGs)
###############################################################################

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.hub_vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "hub_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_firewall_subnet_cidr]
}

resource "azurerm_subnet" "hub_gateway" {
  count                = var.hub_gateway_subnet_cidr != "" ? 1 : 0
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_gateway_subnet_cidr]
}

###############################################################################
# Spoke VNet
###############################################################################

module "spoke_vnet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-vnet?ref=main"

  resource_group_name   = var.resource_group_name
  location              = var.location
  vnet_name             = var.spoke_vnet_name
  vnet_cidr             = var.spoke_vnet_cidr
  host_subnet_name      = var.spoke_host_subnet_name
  host_subnet_cidr      = var.spoke_host_subnet_cidr
  container_subnet_name = var.spoke_container_subnet_name
  container_subnet_cidr = var.spoke_container_subnet_cidr
  nsg_name              = var.spoke_nsg_name
  tags                  = var.tags
}

###############################################################################
# VNet Peering (Hub <-> Spoke)
###############################################################################

module "vnet_peering" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-vnet-peering?ref=main"

  local_vnet_name            = var.hub_vnet_name
  remote_vnet_name           = var.spoke_vnet_name
  local_vnet_id              = azurerm_virtual_network.hub.id
  remote_vnet_id             = module.spoke_vnet.vnet_id
  local_resource_group_name  = var.resource_group_name
  remote_resource_group_name = var.resource_group_name
  allow_forwarded_traffic    = true
}

###############################################################################
# Azure Firewall
###############################################################################

module "firewall" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-firewall?ref=main"

  resource_group_name       = var.resource_group_name
  location                  = var.location
  firewall_name             = var.firewall_name
  firewall_subnet_id        = azurerm_subnet.hub_firewall.id
  spoke_subnet_ids          = [module.spoke_vnet.host_subnet_id, module.spoke_vnet.container_subnet_id]
  allowed_spoke_cidr_ranges = [var.spoke_host_subnet_cidr, var.spoke_container_subnet_cidr]
  service_tag_rules         = var.service_tag_rules
  tags                      = var.tags
}
