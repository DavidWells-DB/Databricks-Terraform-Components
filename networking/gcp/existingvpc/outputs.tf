output "network_self_link" {
  value       = data.google_compute_network.this.self_link
  description = "Self-link of the referenced VPC."
}

output "subnetwork_self_link" {
  value       = data.google_compute_subnetwork.this.self_link
  description = "Self-link of the referenced subnetwork."
}

output "databricks_network_id" {
  value       = databricks_mws_networks.this.network_id
  description = "Databricks network registration ID."
}

output "network_cidr" {
  value       = data.google_compute_subnetwork.this.ip_cidr_range
  description = "Primary CIDR of the referenced subnetwork."
}

output "cloud_nat_id" {
  value       = var.existing_cloud_nat_id
  description = "Optional referenced Cloud NAT ID."
}

output "cloud_router_id" {
  value       = var.existing_cloud_router_id
  description = "Optional referenced Cloud Router ID."
}

output "network_name" {
  value       = data.google_compute_network.this.name
  description = "Name of the referenced VPC."
}

output "subnetwork_name" {
  value       = data.google_compute_subnetwork.this.name
  description = "Name of the referenced subnetwork."
}

output "cloud_nat_name" {
  value       = var.existing_cloud_nat_id == null ? null : element(split("/", var.existing_cloud_nat_id), length(split("/", var.existing_cloud_nat_id)) - 1)
  description = "Name derived from an optional existing Cloud NAT ID."
}

output "cloud_router_name" {
  value       = var.existing_cloud_router_id == null ? null : element(split("/", var.existing_cloud_router_id), length(split("/", var.existing_cloud_router_id)) - 1)
  description = "Name derived from an optional existing Cloud Router ID."
}
