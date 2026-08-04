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

output "host_subnet_nsg_association_id" {
  description = "NSG association ID for the host (public) subnet. Pass to azure-account-workspace as public_subnet_network_security_group_association_id — required for VNet injection."
  value       = module.vnet.host_subnet_nsg_association_id
}

output "container_subnet_nsg_association_id" {
  description = "NSG association ID for the container (private) subnet. Pass to azure-account-workspace as private_subnet_network_security_group_association_id — required for VNet injection."
  value       = module.vnet.container_subnet_nsg_association_id
}
