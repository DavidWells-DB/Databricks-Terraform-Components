output "storage_configuration_id" {
  description = "Databricks storage registration ID."
  value       = databricks_mws_storage_configurations.this.storage_configuration_id
}

output "bucket_name" {
  description = "Name of the referenced existing bucket."
  value       = data.aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the referenced existing bucket."
  value       = data.aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Regional domain name of the referenced existing bucket."
  value       = data.aws_s3_bucket.this.bucket_regional_domain_name
}

output "databricks_aws_account_id" {
  description = "Databricks control-plane AWS account ID for the selected shard."
  value = (
    var.databricks_gov_shard == "civilian" ? "044793339203" :
    var.databricks_gov_shard == "dod" ? "170661010020" :
    "414351767826"
  )
}
