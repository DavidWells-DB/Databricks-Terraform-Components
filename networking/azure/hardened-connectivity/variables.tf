###############################################################################
# VNet Variables
###############################################################################

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "host_subnet_name" {
  description = "Name of the host (public) subnet for Databricks"
  type        = string
  default     = "host-subnet"
}

variable "host_subnet_cidr" {
  description = "CIDR block for the host subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "container_subnet_name" {
  description = "Name of the container (private) subnet for Databricks"
  type        = string
  default     = "container-subnet"
}

variable "container_subnet_cidr" {
  description = "CIDR block for the container subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "pe_subnet_name" {
  description = "Name of the Private Endpoint subnet"
  type        = string
  default     = "pe-subnet"
}

variable "pe_subnet_cidr" {
  description = "CIDR block for the Private Endpoint subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "databricks-nsg"
}

###############################################################################
# Private Endpoint Variables
###############################################################################

variable "workspace_resource_id" {
  description = "Resource ID of the Databricks workspace (from the blueprint layer)"
  type        = string
}

###############################################################################
# Common
###############################################################################

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
