variable "resource_prefix" {
  type        = string
  description = "Prefix used when resource_group_name is null."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "Optional resource-group creation name. Null derives '<resource_prefix>-rg'."
  default     = null
}

variable "location" {
  type        = string
  description = "Azure region for the resource group."
  nullable    = false
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the resource group."
  default     = {}
}
