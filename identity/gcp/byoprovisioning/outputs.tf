output "service_account_email" {
  value       = data.google_service_account.this.email
  description = "Referenced service-account email."
}

output "service_account_id" {
  value       = data.google_service_account.this.name
  description = "Referenced service-account resource ID."
}

output "service_account_unique_id" {
  value       = data.google_service_account.this.unique_id
  description = "Referenced service-account unique ID."
}

output "custom_role_id" {
  value       = var.existing_custom_role_id
  description = "Referenced IAM role ID."
}

output "databricks_user_id" {
  value       = databricks_user.this.id
  description = "Databricks account-user ID for the service account."
}
