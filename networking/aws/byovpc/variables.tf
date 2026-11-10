variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID for the mws_networks registration."
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for the created security group name and the default network registration name."
}

variable "existing_vpc_id" {
  type        = string
  description = "ID of the EXISTING customer VPC to register (BYO network foundation). This component creates no VPC, subnets, or NAT — bring your own egress."
}

variable "existing_private_subnet_ids" {
  description = "Map of caller-chosen subnet names to the EXISTING private (workspace node) subnet IDs. A map, never a list — the twice-proven pattern (aws-account-network-vpc v0.3.0, azure-account-network-firewall v0.2.0) so caller keys stay stable. Databricks requires subnets across >= 2 AZs."
  type        = map(string)

  validation {
    condition     = length(var.existing_private_subnet_ids) >= 2
    error_message = "At least 2 private subnet IDs are required (Databricks requires nodes across >= 2 AZs)."
  }
}

variable "existing_security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to the Databricks registration when you bring your own (must allow node-to-node within the group and outbound to the control plane — the Databricks classic-compute requirements). Null (default) = the component creates the Databricks-required security group in the existing VPC."
  default     = null
}

variable "existing_privatelink_subnet_ids" {
  type        = map(string)
  description = "Map of caller-chosen names to EXISTING subnet IDs for back-end PrivateLink VPC endpoints, when composing aws-account-network-privatelink-endpoints against the BYO VPC. Empty (default) = no PrivateLink composition."
  default     = {}
}

variable "existing_public_subnet_ids" {
  type        = map(string)
  description = "Optional echo passthrough of EXISTING public (NAT) subnet IDs, enabling aws-account-network-egress-internet composition on the BYO VPC when the customer wants managed NAT. The component itself uses these for nothing."
  default     = {}
}

variable "existing_private_route_table_ids" {
  type        = map(string)
  description = "Optional echo passthrough of EXISTING private route-table IDs, for egress/vpc-endpoints module composition on the BYO VPC. The component itself uses these for nothing."
  default     = {}
}

variable "network_name" {
  type        = string
  description = "Base name for the databricks_mws_networks registration(s). Null (default) derives \"<resource_prefix>-network\". A \"<network_name>-privatelink\" registration is added alongside when PrivateLink is enabled, so the value is capped at 88."
  default     = null

  validation {
    condition     = var.network_name == null || (length(var.network_name) >= 1 && length(var.network_name) <= 88 && can(regex("^[A-Za-z0-9_-]+$", var.network_name)))
    error_message = "network_name must be null or 1-88 characters of alphanumeric, underscore, or hyphen (capped at 88 to leave room for the \"-privatelink\" suffix)."
  }
}

variable "enable_privatelink" {
  type        = bool
  description = "Plan-time switch adding the \"<network_name>-privatelink\" registration for back-end PrivateLink. The registration is retained alongside \"base\" (retain-old-config model, verified live 2026-09-29); the caller repoints the workspace to the PrivateLink registration in place."
  default     = false
}

variable "vpc_endpoint_ids" {
  type = object({
    rest_api_id = optional(string)
    relay_id    = optional(string)
  })
  description = "Back-end PrivateLink VPC endpoint IDs (from aws-account-network-privatelink-endpoints) registered into the privatelink network config. Null (default) = no PrivateLink endpoints. Key set stays plan-time via enable_privatelink — these IDs are usually known only after apply."
  default     = null
}

variable "databricks_gov_shard" {
  type        = string
  description = "Databricks Government shard (null for commercial, 'civilian' or 'dod' for GovCloud)."
  default     = null

  validation {
    condition     = var.databricks_gov_shard == null || contains(["civilian", "dod"], var.databricks_gov_shard)
    error_message = "databricks_gov_shard must be null, \"civilian\", or \"dod\"."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the created security group."
  default     = {}
}
