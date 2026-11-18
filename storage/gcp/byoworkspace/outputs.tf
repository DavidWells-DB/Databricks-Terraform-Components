output "storage_configuration_id" {
  value       = databricks_mws_storage_configurations.this.storage_configuration_id
  description = "Databricks storage registration ID."
}

output "bucket_name" {
  value       = data.google_storage_bucket.this.name
  description = "Referenced bucket name."
}

output "bucket_url" {
  value       = data.google_storage_bucket.this.url
  description = "Referenced bucket URL."
}

output "bucket_self_link" {
  value       = data.google_storage_bucket.this.self_link
  description = "Referenced bucket self-link."
}
