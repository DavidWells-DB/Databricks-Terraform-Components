output "metastore_id" {
  description = "The ID of the created Unity Catalog metastore."
  value       = module.metastore.metastore_id
}

output "storage_credential_id" {
  description = "The storage credential ID, or null for a storageless metastore."
  value       = local.create_storage ? try(module.storage_credential[0].storage_credential_id, null) : null
}

output "assignment_ids" {
  description = "Map of workspace labels to metastore assignment IDs. Empty when no workspace_ids were provided."
  value       = try(module.metastore_assignment[0].assignment_ids, {})
}

output "iam_role_arn" {
  description = "The IAM role ARN created for the storage credential, or null for a storageless metastore."
  value       = try(module.storage_credential[0].iam_role_arn, null)
}
