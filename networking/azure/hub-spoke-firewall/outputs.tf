###############################################################################
# Hub VNet Outputs
###############################################################################

output "hub_vnet_id" {
  description = "ID of the hub Virtual Network"
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub Virtual Network"
  value       = azurerm_virtual_network.hub.name
}

###############################################################################
# Spoke VNet Outputs
###############################################################################

output "spoke_vnet_id" {
  description = "ID of the spoke Virtual Network"
  value       = module.spoke_vnet.vnet_id
}

output "spoke_vnet_name" {
  description = "Name of the spoke Virtual Network"
  value       = module.spoke_vnet.vnet_name
}

output "host_subnet_id" {
  description = "ID of the host subnet in the spoke"
  value       = module.spoke_vnet.host_subnet_id
}

output "host_subnet_name" {
  description = "Name of the host subnet in the spoke"
  value       = module.spoke_vnet.host_subnet_name
}

output "container_subnet_id" {
  description = "ID of the container subnet in the spoke"
  value       = module.spoke_vnet.container_subnet_id
}

output "container_subnet_name" {
  description = "Name of the container subnet in the spoke"
  value       = module.spoke_vnet.container_subnet_name
}

output "spoke_nsg_id" {
  description = "ID of the NSG in the spoke"
  value       = module.spoke_vnet.nsg_id
}

###############################################################################
# Firewall Outputs
###############################################################################

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall"
  value       = module.firewall.firewall_private_ip
}

output "firewall_id" {
  description = "ID of the Azure Firewall"
  value       = module.firewall.firewall_id
}
