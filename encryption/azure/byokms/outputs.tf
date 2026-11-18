output "managed_services_key_id" {
  value       = var.existing_managed_services_key_id
  description = "Referenced managed-services key ID."
}

output "managed_disk_key_id" {
  value       = var.existing_managed_disk_key_id
  description = "Referenced managed-disk key ID."
}

output "workspace_storage_key_id" {
  value       = var.existing_workspace_storage_key_id
  description = "Referenced root-storage key ID."
}

output "key_vault_id" {
  value       = var.existing_key_vault_id
  description = "Optional referenced Key Vault ARM ID."
}

output "managed_services_key_versionless_id" {
  value       = join("/", slice(split("/", var.existing_managed_services_key_id), 0, length(split("/", var.existing_managed_services_key_id)) - 1))
  description = "Versionless managed-services key URL."
}

output "managed_disk_key_versionless_id" {
  value       = join("/", slice(split("/", var.existing_managed_disk_key_id), 0, length(split("/", var.existing_managed_disk_key_id)) - 1))
  description = "Versionless managed-disk key URL."
}

output "workspace_storage_key_versionless_id" {
  value       = join("/", slice(split("/", var.existing_workspace_storage_key_id), 0, length(split("/", var.existing_workspace_storage_key_id)) - 1))
  description = "Versionless root-storage key URL."
}
