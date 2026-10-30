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

output "iam_role_arn" {
  description = "The IAM role ARN created for the storage credential, or null when no credential was created."
  value       = try(module.storage_credential[0].iam_role_arn, null)
}

output "catalog_storage_root" {
  description = "The managed storage root the catalog actually uses: the adopted root, the created bucket (+ path suffix), or empty when the catalog uses metastore-default storage."
  value       = local.effective_storage_root
}

output "created_bucket_name" {
  description = "Name of the dedicated bucket created for the catalog's managed storage, or null when storage was adopted or not used."
  value       = local.create_storage ? try(module.uc_storage[0].bucket_name, null) : null
}
