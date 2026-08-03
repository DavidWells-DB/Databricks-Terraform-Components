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
