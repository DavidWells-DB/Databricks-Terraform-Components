output "managed_services_key_id" {
  description = "Databricks managed-services CMK registration ID."
  value       = databricks_mws_customer_managed_keys.managed_services.customer_managed_key_id
}

output "workspace_storage_key_id" {
  description = "Databricks workspace-storage CMK registration ID."
  value       = databricks_mws_customer_managed_keys.workspace_storage.customer_managed_key_id
}

output "managed_services_key_arn" {
  description = "ARN of the referenced managed-services KMS key."
  value       = data.aws_kms_key.managed_services.arn
}

output "workspace_storage_key_arn" {
  description = "ARN of the referenced workspace-storage KMS key."
  value       = data.aws_kms_key.workspace_storage.arn
}

output "managed_services_key_alias" {
  description = "Alias supplied for the managed-services key."
  value       = var.existing_managed_services_key_alias
}

output "workspace_storage_key_alias" {
  description = "Alias supplied for the workspace-storage key."
  value       = var.existing_workspace_storage_key_alias
}

output "databricks_control_plane_aws_account_id" {
  description = "Databricks control-plane AWS account ID for the selected shard."
  value = (
    var.databricks_gov_shard == "civilian" ? "044793339203" :
    var.databricks_gov_shard == "dod" ? "170661010020" :
    "414351767826"
  )
}
