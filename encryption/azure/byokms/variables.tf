variable "existing_managed_services_key_id" {
  type        = string
  description = "Existing versioned Key Vault key URL for managed services."
  nullable    = false

  validation {
    condition     = can(regex("^https://[^/]+/keys/[^/]+/[^/]+$", var.existing_managed_services_key_id))
    error_message = "existing_managed_services_key_id must be a versioned Key Vault key URL."
  }
}

variable "existing_managed_disk_key_id" {
  type        = string
  description = "Existing versioned Key Vault key URL for managed disks."
  nullable    = false

  validation {
    condition     = can(regex("^https://[^/]+/keys/[^/]+/[^/]+$", var.existing_managed_disk_key_id))
    error_message = "existing_managed_disk_key_id must be a versioned Key Vault key URL."
  }
}

variable "existing_workspace_storage_key_id" {
  type        = string
  description = "Existing versioned Key Vault key URL for root DBFS storage."
  nullable    = false

  validation {
    condition     = can(regex("^https://[^/]+/keys/[^/]+/[^/]+$", var.existing_workspace_storage_key_id))
    error_message = "existing_workspace_storage_key_id must be a versioned Key Vault key URL."
  }
}

variable "existing_key_vault_id" {
  type        = string
  description = "Optional ARM Key Vault resource ID, required by the root-DBFS resource when the vault is in another subscription."
  default     = null
}
