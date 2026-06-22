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

variable "firewall_subnet_cidrs" {
  description = "CIDR blocks for firewall subnets (AWS Network Firewall endpoints)"
  type        = list(string)
  default     = []
}

variable "firewall_name" {
  description = "Name for the AWS Network Firewall"
  type        = string
  default     = ""
}

variable "firewall_stateful_rule_group_arns" {
  description = "List of ARNs for stateful rule groups to attach to the firewall policy"
  type        = list(string)
  default     = []
}

variable "firewall_stateless_rule_group_arns" {
  description = "List of ARNs for stateless rule groups to attach to the firewall policy"
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
