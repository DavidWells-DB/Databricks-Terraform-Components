output "spoke_network_self_link" {
  description = "Self-link of the spoke VPC network (Databricks workspace)"
  value       = module.spoke_vpc.network_self_link
}

output "spoke_subnetwork_self_link" {
  description = "Self-link of the spoke workspace subnet"
  value       = module.spoke_vpc.subnetwork_self_link
}

output "databricks_network_id" {
  description = "Databricks network configuration ID"
  value       = module.spoke_vpc.databricks_network_id
}

output "hub_network_self_link" {
  description = "Self-link of the hub VPC network"
  value       = google_compute_network.hub.self_link
}

output "psc_subnet_self_link" {
  description = "Self-link of the PSC endpoint subnet"
  value       = google_compute_subnetwork.psc.self_link
}

output "private_access_settings_id" {
  description = "Databricks private access settings ID"
  value       = module.psc_endpoints.private_access_settings_id
}

output "workspace_psc_ip" {
  description = "IP address of the workspace PSC endpoint"
  value       = module.psc_endpoints.workspace_psc_ip
}

output "relay_psc_ip" {
  description = "IP address of the relay PSC endpoint"
  value       = module.psc_endpoints.relay_psc_ip
}
