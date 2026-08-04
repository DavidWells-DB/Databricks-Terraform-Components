variable "databricks_account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "region" {
  description = "AWS region for the networking resources"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to spread the network across when availability_zones is not supplied. Databricks requires at least 2. Ignored when availability_zones is set explicitly."
  type        = number
  default     = 2
  validation {
    condition     = var.az_count >= 2
    error_message = "az_count must be at least 2 (Databricks requires nodes across >= 2 AZs)."
  }
}

variable "availability_zones" {
  description = "List of availability zones to use. Leave empty (default) to auto-select the first az_count available zones in the region."
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (Databricks workspace nodes). Leave empty (default) to derive one /20 per AZ from vpc_cidr."
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (NAT gateways). Leave empty (default) to derive one /24 per AZ from vpc_cidr."
  type        = list(string)
  default     = []
}

variable "databricks_gov_shard" {
  description = "Databricks Government shard (null for commercial, 'civilian' or 'dod' for GovCloud)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_privatelink_subnets" {
  description = "Create dedicated PrivateLink subnets (one per AZ) for back-end PrivateLink VPC endpoints. Set true when composing aws-account-network-privatelink-endpoints against this Component. This is a plan-time boolean and is INDEPENDENT of vpc_endpoint_ids — the endpoints are placed in these subnets, so keying subnet creation off the endpoint IDs would create a dependency cycle."
  type        = bool
  default     = false
}

variable "privatelink_subnet_cidrs" {
  description = "Explicit CIDR blocks for the dedicated PrivateLink subnets (one per AZ). Leave empty (default) to derive one /24 per AZ from vpc_cidr when enable_privatelink_subnets = true. Empty when PrivateLink is not used."
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_ids" {
  description = "Optional back-end PrivateLink VPC endpoint IDs (from aws-account-network-privatelink-endpoints), registered into databricks_mws_networks so the workspace routes control-plane + SCC-relay traffic over PrivateLink. null (default) = no PrivateLink registration. Passing these does NOT create a dependency cycle — the endpoints depend on this Component's VPC, and mws_networks depends on the endpoints (verified acyclic)."
  type = object({
    rest_api_id = optional(string)
    relay_id    = optional(string)
  })
  default = null
}
