output "network_id" {
  description = "Databricks network configuration ID"
  value       = module.vpc.databricks_network_id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "privatelink_subnet_ids" {
  description = "Map of PrivateLink subnet IDs"
  value       = module.vpc.privatelink_subnet_ids
}

output "security_group_id" {
  description = "ID of the Databricks workspace security group"
  value       = module.vpc.security_group_id
}

output "private_access_settings_id" {
  description = "Databricks private access settings ID"
  value       = module.privatelink_endpoints.private_access_settings_id
}

output "workspace_vpc_endpoint_id" {
  description = "VPC endpoint ID for the workspace (REST API) endpoint"
  value       = module.privatelink_endpoints.workspace_vpc_endpoint_id
}

output "relay_vpc_endpoint_id" {
  description = "VPC endpoint ID for the relay (SCC) endpoint"
  value       = module.privatelink_endpoints.relay_vpc_endpoint_id
}

output "private_route_table_ids" {
  description = "Map of private route table IDs"
  value       = module.vpc.private_route_table_ids
}
