###############################################################################
# Common Variables
###############################################################################

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

###############################################################################
# Hub VPC Variables
###############################################################################

variable "hub_vpc_cidr" {
  description = "CIDR block for the hub VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "hub_availability_zones" {
  description = "List of availability zones for the hub VPC"
  type        = list(string)
  default     = []
}

variable "hub_public_subnet_cidrs" {
  description = "CIDR blocks for hub public subnets (NAT gateways)"
  type        = list(string)
  default     = []
}

variable "hub_firewall_subnet_cidrs" {
  description = "CIDR blocks for hub firewall subnets"
  type        = list(string)
  default     = []
}

variable "hub_private_subnet_cidrs" {
  description = "CIDR blocks for hub private subnets (transit gateway attachments)"
  type        = list(string)
  default     = []
}

variable "firewall_name" {
  description = "Name for the AWS Network Firewall in the hub"
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

###############################################################################
# Spoke VPC Variables
###############################################################################

variable "spoke_vpc_cidr" {
  description = "CIDR block for the spoke VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "spoke_availability_zones" {
  description = "List of availability zones for the spoke VPC"
  type        = list(string)
  default     = []
}

variable "spoke_private_subnet_cidrs" {
  description = "CIDR blocks for spoke private subnets (Databricks workspace nodes)"
  type        = list(string)
  default     = []
}

variable "spoke_privatelink_subnet_cidrs" {
  description = "CIDR blocks for spoke PrivateLink subnets"
  type        = list(string)
  default     = []
}

###############################################################################
# Transit Gateway Variables
###############################################################################

variable "tgw_asn" {
  description = "BGP ASN for the Transit Gateway"
  type        = number
  default     = 64512
}

###############################################################################
# PrivateLink Variables
###############################################################################

variable "enable_privatelink" {
  description = "Whether to enable PrivateLink endpoints in the spoke VPC"
  type        = bool
  default     = true
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
