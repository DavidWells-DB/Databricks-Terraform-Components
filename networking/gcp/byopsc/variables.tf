variable "existing_private_access_settings_id" {
  type        = string
  description = "Existing Databricks Private Access Settings ID."
  nullable    = false
}

variable "existing_workspace_psc_endpoint_id" {
  type        = string
  description = "Existing Databricks registration ID for the workspace PSC endpoint."
  nullable    = false
}

variable "existing_relay_psc_endpoint_id" {
  type        = string
  description = "Existing Databricks registration ID for the SCC relay PSC endpoint."
  nullable    = false
}
