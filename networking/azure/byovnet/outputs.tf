output "vnet_id" {
  value       = data.azurerm_virtual_network.this.id
  description = "Resource ID of the referenced VNet."
}

output "vnet_name" {
  value       = data.azurerm_virtual_network.this.name
  description = "Name of the referenced VNet."
}

output "host_subnet_id" {
  value       = data.azurerm_subnet.host.id
  description = "Resource ID of the referenced host subnet."
}

output "host_subnet_name" {
  value       = data.azurerm_subnet.host.name
  description = "Name of the referenced host subnet."
}

output "container_subnet_id" {
  value       = data.azurerm_subnet.container.id
  description = "Resource ID of the referenced container subnet."
}

output "container_subnet_name" {
  value       = data.azurerm_subnet.container.name
  description = "Name of the referenced container subnet."
}

output "nsg_id" {
  value       = data.azurerm_subnet.host.network_security_group_id
  description = "NSG ID read from the host subnet."
}

output "nsg_name" {
  value       = element(split("/", data.azurerm_subnet.host.network_security_group_id), length(split("/", data.azurerm_subnet.host.network_security_group_id)) - 1)
  description = "NSG name read from the host subnet."
}

output "host_subnet_nsg_association_id" {
  value       = var.existing_host_subnet_nsg_association_id
  description = "Caller-supplied host NSG association ID."
}

output "container_subnet_nsg_association_id" {
  value       = var.existing_container_subnet_nsg_association_id
  description = "Caller-supplied container NSG association ID."
}

output "pe_subnet_id" {
  value       = var.existing_pe_subnet_id
  description = "Optional private-endpoint subnet ID."
}
