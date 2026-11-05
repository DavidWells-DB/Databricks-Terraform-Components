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
  description = "Optional name for the private-endpoint subnet. When null (default), no PE subnet is created. Set (with pe_subnet_cidr) when front-end Private Link private endpoints will be created against this VNet (the azure-account-network-private-endpoints module needs a dedicated subnet)."
  type        = string
  default     = null
}

variable "pe_subnet_cidr" {
  description = "CIDR for the optional private-endpoint subnet (e.g. \"10.0.3.0/27\"). Required when pe_subnet_name is set; ignored when null."
  type        = string
  default     = null
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "databricks-nsg"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
