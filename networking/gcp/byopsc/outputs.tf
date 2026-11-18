output "private_access_settings_id" {
  value       = var.existing_private_access_settings_id
  description = "Referenced Private Access Settings ID."
}

output "workspace_psc_endpoint_id" {
  value       = var.existing_workspace_psc_endpoint_id
  description = "Referenced workspace PSC endpoint registration ID."
}

output "relay_psc_endpoint_id" {
  value       = var.existing_relay_psc_endpoint_id
  description = "Referenced relay PSC endpoint registration ID."
}
