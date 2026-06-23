###############################################################################
# Feature Toggles
###############################################################################

variable "enable_ncc" {
  description = "Create the Network Connectivity Config for serverless compute. Disable for a classic-only deployment."
  type        = bool
  default     = true
}

variable "enable_vnet" {
  description = "Create the VNet (with subnets/NSG) for classic compute. Disable for a serverless-only deployment."
  type        = bool
  default     = true
}

###############################################################################
# NCC Variables (required when enable_ncc = true)
###############################################################################

variable "databricks_account_id" {
  description = "Databricks account ID. Required when enable_ncc = true."
  type        = string
  default     = ""
}

variable "ncc_name" {
  description = "Name of the Network Connectivity Config. Required when enable_ncc = true."
  type        = string
  default     = ""
}

variable "ncc_region" {
  description = "Azure region for the Network Connectivity Config. Required when enable_ncc = true."
  type        = string
  default     = ""
}

###############################################################################
# VNet Variables (Classic Compute; required when enable_vnet = true)
###############################################################################

variable "resource_group_name" {
  description = "Name of the Azure resource group. Required when enable_vnet = true."
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region for VNet resources. Required when enable_vnet = true."
  type        = string
  default     = ""
}

variable "vnet_name" {
  description = "Name of the Virtual Network for classic compute. Required when enable_vnet = true."
  type        = string
  default     = ""
}

variable "vnet_cidr" {
  description = "CIDR block for the Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "host_subnet_name" {
  description = "Name of the host subnet"
  type        = string
  default     = "host-subnet"
}

variable "host_subnet_cidr" {
  description = "CIDR block for the host subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "container_subnet_name" {
  description = "Name of the container subnet"
  type        = string
  default     = "container-subnet"
}

variable "container_subnet_cidr" {
  description = "CIDR block for the container subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "databricks-nsg"
}

###############################################################################
# Common
###############################################################################

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
