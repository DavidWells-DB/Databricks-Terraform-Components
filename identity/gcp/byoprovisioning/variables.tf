variable "project_id" {
  type        = string
  description = "GCP project containing the existing service account and receiving the IAM role binding."
  nullable    = false
}

variable "existing_service_account_email" {
  type        = string
  description = "Email of an existing Databricks provisioning service account."
  nullable    = false

  validation {
    condition     = can(regex("^[^@]+@[^@]+\\.iam\\.gserviceaccount\\.com$", var.existing_service_account_email))
    error_message = "existing_service_account_email must be a GCP service-account email."
  }
}

variable "existing_custom_role_id" {
  type        = string
  description = "Existing custom or predefined IAM role to bind to the service account, for example projects/my-project/roles/DbxProvisioner."
  nullable    = false
}
