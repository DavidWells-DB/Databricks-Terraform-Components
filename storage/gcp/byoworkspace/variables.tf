variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID for the storage registration."
  nullable    = false
}

variable "existing_bucket_name" {
  type        = string
  description = "Name of an existing GCS bucket in the workspace region."
  nullable    = false

  validation {
    condition     = length(var.existing_bucket_name) >= 3 && length(var.existing_bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9._-]*[a-z0-9]$", var.existing_bucket_name))
    error_message = "existing_bucket_name must be a valid GCS bucket name."
  }
}

variable "databricks_service_account_email" {
  type        = string
  description = "Existing provisioning service account that receives the required bucket IAM memberships."
  nullable    = false

  validation {
    condition     = can(regex("^[^@]+@[^@]+\\.iam\\.gserviceaccount\\.com$", var.databricks_service_account_email))
    error_message = "databricks_service_account_email must be a GCP service-account email."
  }
}

variable "storage_configuration_name" {
  type        = string
  description = "Databricks storage registration name."
  nullable    = false
}
