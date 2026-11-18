variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID for both customer-managed-key registrations."
  nullable    = false
}

variable "existing_managed_services_key_arn" {
  type        = string
  description = "ARN of an existing KMS key for managed services. Its policy must grant the Databricks control plane the required encrypt/decrypt permissions."
  nullable    = false

  validation {
    condition     = can(regex("^arn:(aws|aws-us-gov):kms:[a-z0-9-]+:[0-9]{12}:key/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.existing_managed_services_key_arn))
    error_message = "existing_managed_services_key_arn must be a full KMS key ARN containing the key UUID."
  }
}

variable "existing_managed_services_key_alias" {
  type        = string
  description = "Existing alias for the managed-services key, including the alias/ prefix."
  nullable    = false

  validation {
    condition     = can(regex("^alias/.+$", var.existing_managed_services_key_alias))
    error_message = "existing_managed_services_key_alias must start with alias/."
  }
}

variable "existing_workspace_storage_key_arn" {
  type        = string
  description = "ARN of an existing KMS key for workspace storage. Its policy must grant Databricks and the cross-account role the required DBFS/EBS permissions."
  nullable    = false

  validation {
    condition     = can(regex("^arn:(aws|aws-us-gov):kms:[a-z0-9-]+:[0-9]{12}:key/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.existing_workspace_storage_key_arn))
    error_message = "existing_workspace_storage_key_arn must be a full KMS key ARN containing the key UUID."
  }
}

variable "existing_workspace_storage_key_alias" {
  type        = string
  description = "Existing alias for the workspace-storage key, including the alias/ prefix."
  nullable    = false

  validation {
    condition     = can(regex("^alias/.+$", var.existing_workspace_storage_key_alias))
    error_message = "existing_workspace_storage_key_alias must start with alias/."
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
