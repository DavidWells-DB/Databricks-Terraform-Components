# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------

output "metastore_id" {
  description = "The ID of the created Unity Catalog metastore."
  value       = module.metastore.metastore_id
}

output "storage_credential_id" {
  description = "The ID of the storage credential created for the metastore."
  value       = local.storage_credential_id
}

output "assignment_ids" {
  description = "Map of workspace labels to their metastore assignment IDs. Empty when no workspace_ids were provided."
  value       = try(module.metastore_assignment[0].assignment_ids, {})
}

output "aws_iam_role_arn" {
  description = "(AWS) The IAM role ARN created for the storage credential."
  value       = var.cloud == "aws" ? try(module.aws_storage_credential[0].iam_role_arn, "") : ""
}

output "azure_access_connector_id" {
  description = "(Azure) The access connector ID created for the storage credential."
  value       = var.cloud == "azure" ? try(module.azure_storage_credential[0].access_connector_id, "") : ""
}

output "gcp_service_account_email" {
  description = "(GCP) The Databricks service account email for the storage credential."
  value       = var.cloud == "gcp" ? try(module.gcp_storage_credential[0].databricks_service_account_email, "") : ""
}
