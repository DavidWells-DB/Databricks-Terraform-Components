output "private_access_settings_id" {
  value       = var.existing_private_access_settings_id
  description = "Referenced Private Access Settings ID."
}

output "workspace_vpc_endpoint_id" {
  value       = var.existing_workspace_vpc_endpoint_id
  description = "Referenced workspace endpoint registration ID."
}

output "relay_vpc_endpoint_id" {
  value       = var.existing_relay_vpc_endpoint_id
  description = "Referenced relay endpoint registration ID."
}
