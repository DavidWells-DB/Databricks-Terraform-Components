###############################################################################
# Isolated Component
# Full Private Link + Azure Firewall + Hub-Spoke Topology
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

resource "azurerm_subnet" "hub_pe" {
  name                 = var.hub_pe_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_pe_subnet_cidr]
}

###############################################################################
# Spoke VNet
###############################################################################

module "spoke_vnet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-vnet?ref=azure-account-network-vnet/v0.1.0"

  resource_group_name   = var.resource_group_name
  location              = var.location
  vnet_name             = var.spoke_vnet_name
  vnet_cidr             = var.spoke_vnet_cidr
  host_subnet_name      = var.spoke_host_subnet_name
  host_subnet_cidr      = var.spoke_host_subnet_cidr
  container_subnet_name = var.spoke_container_subnet_name
  container_subnet_cidr = var.spoke_container_subnet_cidr
  pe_subnet_name        = var.spoke_pe_subnet_name
  pe_subnet_cidr        = var.spoke_pe_subnet_cidr
  nsg_name              = var.spoke_nsg_name
  tags                  = var.tags
}

###############################################################################
# VNet Peering (Hub <-> Spoke)
###############################################################################

module "vnet_peering" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-vnet-peering?ref=azure-account-network-vnet-peering/v0.1.0"

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
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-firewall?ref=azure-account-network-firewall/v0.1.0"

  resource_group_name     = var.resource_group_name
  location                = var.location
  firewall_name           = var.firewall_name
  firewall_subnet_id      = azurerm_subnet.hub_firewall.id
  spoke_subnet_ids        = [module.spoke_vnet.host_subnet_id, module.spoke_vnet.container_subnet_id]
  allowed_spoke_cidr_ranges = [var.spoke_host_subnet_cidr, var.spoke_container_subnet_cidr]
  service_tag_rules       = var.service_tag_rules
  tags                    = var.tags
}

###############################################################################
# Private Endpoints — hub (front-end + browser auth) via module
# The module creates the shared Private DNS zone and VNet link.
###############################################################################

module "private_endpoints" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-account-network-private-endpoints?ref=azure-account-network-private-endpoints/v0.1.0"

  resource_group_name    = var.resource_group_name
  location               = var.location
  workspace_resource_id  = var.workspace_resource_id
  pe_subnet_id           = azurerm_subnet.hub_pe.id
  vnet_id                = azurerm_virtual_network.hub.id
  hub_vnet_ids           = [module.spoke_vnet.vnet_id]
  enable_front_end_pe    = true
  enable_browser_auth_pe = true
  tags                   = var.tags
}

###############################################################################
# Private Endpoints — spoke (back-end only, reuses the DNS zone from above)
###############################################################################

locals {
  workspace_name = element(split("/", var.workspace_resource_id), length(split("/", var.workspace_resource_id)) - 1)
}

resource "azurerm_private_endpoint" "backend" {
  name                = "${local.workspace_name}-spoke-be-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.spoke_vnet.pe_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${local.workspace_name}-spoke-be-pe"
    private_connection_resource_id = var.workspace_resource_id
    subresource_names              = ["databricks_ui_api"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "databricks-dns"
    private_dns_zone_ids = [module.private_endpoints.private_dns_zone_id]
  }
}
