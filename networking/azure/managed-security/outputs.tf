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

output "nsg_id" {
  description = "ID of the Network Security Group"
  value       = module.vnet.nsg_id
}
