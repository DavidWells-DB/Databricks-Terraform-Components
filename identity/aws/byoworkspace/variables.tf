variable "resource_prefix" {
  type        = string
  description = "Prefix used for the default Databricks credentials registration name."
  nullable    = false
}

variable "existing_role_arn" {
  type        = string
  description = "ARN of an existing cross-account IAM role. The role must already trust the correct Databricks account with the account ID as external ID and grant the required workspace permissions."
  nullable    = false

  validation {
    condition     = can(regex("^arn:(aws|aws-us-gov):iam::[0-9]{12}:role/.+$", var.existing_role_arn))
    error_message = "existing_role_arn must be a full IAM role ARN in the aws or aws-us-gov partition."
  }
}

variable "credentials_name" {
  type        = string
  description = "Optional Databricks credentials registration name. Null derives '<resource_prefix>-creds'."
  default     = null

  validation {
    condition     = var.credentials_name == null || (length(var.credentials_name) <= 100 && can(regex("^[A-Za-z0-9_-]+$", var.credentials_name)))
    error_message = "credentials_name must contain 1-100 alphanumeric, underscore, or hyphen characters."
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
