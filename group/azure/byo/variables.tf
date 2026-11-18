variable "existing_resource_group_id" {
  type        = string
  description = "Full ARM ID of an existing resource group."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+$", var.existing_resource_group_id))
    error_message = "existing_resource_group_id must be a full resource-group ARM ID."
  }
}

variable "location" {
  type        = string
  description = "Required workspace location. The referenced resource group must be in the same region."
  nullable    = false
}
