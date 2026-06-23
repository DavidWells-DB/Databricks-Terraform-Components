###############################################################################
# NCC Outputs
###############################################################################

output "ncc_id" {
  description = "ID of the Network Connectivity Config (null when enable_ncc = false)"
  value       = try(module.ncc[0].network_connectivity_config_id, null)
}

output "ncc_name" {
  description = "Name of the Network Connectivity Config (null when enable_ncc = false)"
  value       = try(module.ncc[0].ncc_name, null)
}

###############################################################################
# VNet Outputs
###############################################################################

output "vnet_id" {
  description = "ID of the Virtual Network (null when enable_vnet = false)"
  value       = try(module.vnet[0].vnet_id, null)
}

output "vnet_name" {
  description = "Name of the Virtual Network (null when enable_vnet = false)"
  value       = try(module.vnet[0].vnet_name, null)
}

output "host_subnet_id" {
  description = "ID of the host subnet (null when enable_vnet = false)"
  value       = try(module.vnet[0].host_subnet_id, null)
}

output "host_subnet_name" {
  description = "Name of the host subnet (null when enable_vnet = false)"
  value       = try(module.vnet[0].host_subnet_name, null)
}

output "container_subnet_id" {
  description = "ID of the container subnet (null when enable_vnet = false)"
  value       = try(module.vnet[0].container_subnet_id, null)
}

output "container_subnet_name" {
  description = "Name of the container subnet (null when enable_vnet = false)"
  value       = try(module.vnet[0].container_subnet_name, null)
}

output "nsg_id" {
  description = "ID of the Network Security Group (null when enable_vnet = false)"
  value       = try(module.vnet[0].nsg_id, null)
}
