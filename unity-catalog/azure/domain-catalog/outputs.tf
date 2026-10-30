output "catalog_name" {
  description = "The name of the created catalog."
  value       = var.catalog_name
}

output "storage_credential_id" {
  description = "The storage credential ID, or null when the catalog uses metastore-default managed storage."
  value       = local.storage_credential_id
}

output "external_location_ids" {
  description = "Map of external location names to their IDs."
  value       = module.external_locations.external_location_ids
}

output "access_connector_id" {
  description = "The access connector ID created for the storage credential, or null when no credential was created."
  value       = try(module.storage_credential[0].access_connector_id, null)
}

output "catalog_storage_root" {
  description = "The managed storage root the catalog actually uses: the adopted root, the created container (+ path suffix), or empty when the catalog uses metastore-default storage."
  value       = local.effective_storage_root
}

output "created_storage_account_id" {
  description = "ARM resource ID of the dedicated storage account created for the catalog's managed storage, or null when storage was adopted or not used."
  value       = local.create_storage ? try(module.uc_storage[0].storage_account_id, null) : null
}

output "created_container_name" {
  description = "Name of the dedicated container created for the catalog's managed storage, or null when storage was adopted or not used."
  value       = local.create_storage ? try(module.uc_storage[0].container_name, null) : null
}
