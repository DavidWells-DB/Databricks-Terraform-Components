variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID for the network registration."
  nullable    = false
}

variable "region" {
  type        = string
  description = "Workspace region. The existing subnetwork must be in this region."
  nullable    = false
}

variable "existing_network_self_link" {
  type        = string
  description = "Full Compute API self-link of an existing VPC."
  nullable    = false

  validation {
    condition     = can(regex("^https://www\\.googleapis\\.com/compute/v1/projects/[^/]+/global/networks/[^/]+$", var.existing_network_self_link))
    error_message = "existing_network_self_link must be a full Compute API VPC self-link."
  }
}

variable "existing_subnetwork_self_link" {
  type        = string
  description = "Full Compute API self-link of the existing Databricks node subnetwork, including its required pod and service secondary ranges."
  nullable    = false

  validation {
    condition     = can(regex("^https://www\\.googleapis\\.com/compute/v1/projects/[^/]+/regions/${var.region}/subnetworks/[^/]+$", var.existing_subnetwork_self_link))
    error_message = "existing_subnetwork_self_link must be a full subnetwork self-link in the workspace region."
  }
}

variable "network_registration_name" {
  type        = string
  description = "Optional Databricks network registration name. Null uses the existing VPC name."
  default     = null

  validation {
    condition     = var.network_registration_name == null || (length(var.network_registration_name) <= 100 && can(regex("^[A-Za-z0-9_-]+$", var.network_registration_name)))
    error_message = "network_registration_name must contain 1-100 alphanumeric, underscore, or hyphen characters."
  }
}

variable "existing_cloud_nat_id" {
  type        = string
  description = "Optional existing Cloud NAT ID for output compatibility. The Component does not modify NAT."
  default     = null
}

variable "existing_cloud_router_id" {
  type        = string
  description = "Optional existing Cloud Router ID for output compatibility. The Component does not modify the router."
  default     = null
}
