output "credentials_id" {
  description = "Databricks credentials registration ID."
  value       = databricks_mws_credentials.this.credentials_id
}

output "role_arn" {
  description = "ARN of the referenced existing role."
  value       = data.aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the referenced existing role."
  value       = data.aws_iam_role.this.name
}

output "databricks_aws_account_id" {
  description = "Databricks control-plane AWS account ID for the selected partition/shard."
  value = (
    var.databricks_gov_shard == "civilian" ? "044793339203" :
    var.databricks_gov_shard == "dod" ? "170661010020" :
    "414351767826"
  )
}
