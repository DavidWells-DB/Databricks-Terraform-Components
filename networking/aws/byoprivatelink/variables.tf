variable "existing_private_access_settings_id" {
  type        = string
  description = "Existing Databricks Private Access Settings ID."
  nullable    = false
}

variable "existing_workspace_vpc_endpoint_id" {
  type        = string
  description = "Existing Databricks registration ID for the workspace/REST VPC endpoint."
  nullable    = false
}

variable "existing_relay_vpc_endpoint_id" {
  type        = string
  description = "Existing Databricks registration ID for the SCC relay VPC endpoint."
  nullable    = false
}
