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

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (Databricks workspace nodes)"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (NAT gateways)"
  type        = list(string)
  default     = []
}

variable "privatelink_subnet_cidrs" {
  description = "CIDR blocks for PrivateLink endpoint subnets"
  type        = list(string)
  default     = []
}

variable "private_access_settings_name" {
  description = "Name for the Databricks private access settings"
  type        = string
  default     = ""
}

variable "workspace_vpc_endpoint_name" {
  description = "Name for the workspace (REST API) VPC endpoint"
  type        = string
  default     = ""
}

variable "relay_vpc_endpoint_name" {
  description = "Name for the relay (SCC) VPC endpoint"
  type        = string
  default     = ""
}

variable "security_group_name" {
  description = "Name for the PrivateLink security group"
  type        = string
  default     = ""
}

variable "security_group_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access PrivateLink endpoints (typically VPC CIDR and any peered VPC CIDRs)"
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
