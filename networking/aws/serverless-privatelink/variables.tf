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

variable "vpc_id" {
  description = "VPC ID where the NLB and VPC Endpoint Service will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the NLB targets"
  type        = list(string)
}

variable "target_ip" {
  description = "IP address of the target service (customer service reachable from the NLB)"
  type        = string
}

variable "target_port" {
  description = "Port of the target service"
  type        = number
}

variable "ncc_name" {
  description = "Name for the Network Connectivity Configuration. Defaults to resource_prefix-ncc"
  type        = string
  default     = ""
}

variable "serverless_privatelink_name" {
  description = "Name for the serverless PrivateLink resources. Defaults to resource_prefix-serverless-pl"
  type        = string
  default     = ""
}

variable "aws_partition" {
  description = "AWS partition (aws or aws-us-gov)"
  type        = string
  default     = "aws"
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
