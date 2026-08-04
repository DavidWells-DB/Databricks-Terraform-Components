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

output "privatelink_subnet_ids" {
  description = "Map of dedicated PrivateLink subnet IDs (empty when back-end PrivateLink is not used). Pass values(...) to aws-account-network-privatelink-endpoints.privatelink_subnet_ids."
  value       = module.vpc.privatelink_subnet_ids
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "security_group_id" {
  description = "ID of the Databricks workspace security group"
  value       = module.vpc.security_group_id
}

output "private_route_table_ids" {
  description = "Map of private route table IDs"
  value       = module.vpc.private_route_table_ids
}
