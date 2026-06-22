###############################################################################
# VNet Outputs
###############################################################################

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = module.vnet.vnet_name
}

output "host_subnet_id" {
  description = "ID of the host subnet"
  value       = module.vnet.host_subnet_id
}

output "host_subnet_name" {
  description = "Name of the host subnet"
  value       = module.vnet.host_subnet_name
}

output "container_subnet_id" {
  description = "ID of the container subnet"
  value       = module.vnet.container_subnet_id
}

output "container_subnet_name" {
  description = "Name of the container subnet"
  value       = module.vnet.container_subnet_name
}

output "pe_subnet_id" {
  description = "ID of the Private Endpoint subnet"
  value       = module.vnet.pe_subnet_id
}

output "nsg_id" {
  description = "ID of the Network Security Group"
  value       = module.vnet.nsg_id
}

###############################################################################
# Private Endpoint Outputs
###############################################################################

output "backend_pe_id" {
  description = "ID of the back-end Private Endpoint"
  value       = module.private_endpoints.back_end_pe_id
}

output "private_dns_zone_id" {
  description = "ID of the Private DNS Zone for Databricks"
  value       = module.private_endpoints.private_dns_zone_id
}
