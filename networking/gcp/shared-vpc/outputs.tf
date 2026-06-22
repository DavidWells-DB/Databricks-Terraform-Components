output "network_self_link" {
  description = "Self-link of the Shared VPC network (in host project)"
  value       = module.vpc.network_self_link
}

output "subnetwork_self_link" {
  description = "Self-link of the workspace subnet (in host project)"
  value       = module.vpc.subnetwork_self_link
}

output "databricks_network_id" {
  description = "Databricks network configuration ID"
  value       = module.vpc.databricks_network_id
}

output "network_cidr" {
  description = "Primary CIDR block of the VPC subnet"
  value       = module.vpc.network_cidr
}

output "cloud_nat_id" {
  description = "ID of the Cloud NAT gateway"
  value       = module.cloud_nat.nat_id
}

output "cloud_router_id" {
  description = "ID of the Cloud Router"
  value       = module.cloud_nat.router_id
}

output "host_project_id" {
  description = "GCP host project ID"
  value       = var.host_project_id
}

output "service_project_ids" {
  description = "List of attached service project IDs"
  value       = var.service_project_ids
}
