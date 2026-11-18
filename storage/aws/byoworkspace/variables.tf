variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID for the storage registration."
  nullable    = false
}

variable "resource_prefix" {
  type        = string
  description = "Prefix used for the default Databricks storage registration name."
  nullable    = false
}

variable "existing_bucket_name" {
  type        = string
  description = "Name of an existing S3 bucket in the workspace region. Its policy, public-access settings, and encryption must already satisfy Databricks root-storage requirements."
  nullable    = false

  validation {
    condition     = length(var.existing_bucket_name) >= 3 && length(var.existing_bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.existing_bucket_name))
    error_message = "existing_bucket_name must be a valid S3 bucket name."
  }
}

variable "storage_configuration_name" {
  type        = string
  description = "Optional Databricks storage registration name. Null derives '<resource_prefix>-storage'."
  default     = null

  validation {
    condition     = var.storage_configuration_name == null || (length(var.storage_configuration_name) <= 100 && can(regex("^[A-Za-z0-9_-]+$", var.storage_configuration_name)))
    error_message = "storage_configuration_name must contain 1-100 alphanumeric, underscore, or hyphen characters."
  }
}

variable "databricks_gov_shard" {
  type        = string
  description = "Databricks GovCloud shard used for the control-plane account output: null, civilian, or dod."
  default     = null

  validation {
    condition     = var.databricks_gov_shard == null || contains(["civilian", "dod"], var.databricks_gov_shard)
    error_message = "databricks_gov_shard must be null, civilian, or dod."
  }
}
