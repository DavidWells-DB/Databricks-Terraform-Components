###############################################################################
# Common Variables
###############################################################################

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

###############################################################################
# Hub VNet Variables
###############################################################################

variable "hub_vnet_name" {
  description = "Name of the hub Virtual Network"
  type        = string
}

variable "hub_vnet_cidr" {
  description = "CIDR block for the hub VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "hub_firewall_subnet_cidr" {
  description = "CIDR block for the AzureFirewallSubnet in the hub"
  type        = string
  default     = "10.1.0.0/26"
}

variable "hub_gateway_subnet_cidr" {
  description = "CIDR block for the GatewaySubnet in the hub (optional, set to empty string to skip)"
  type        = string
  default     = "10.1.1.0/27"
}

variable "hub_pe_subnet_name" {
  description = "Name of the Private Endpoint subnet in the hub"
  type        = string
  default     = "hub-pe-subnet"
}

variable "hub_pe_subnet_cidr" {
  description = "CIDR block for the Private Endpoint subnet in the hub"
  type        = string
  default     = "10.1.2.0/24"
}

###############################################################################
# Spoke VNet Variables
###############################################################################

variable "spoke_vnet_name" {
  description = "Name of the spoke Virtual Network"
  type        = string
}

variable "spoke_vnet_cidr" {
  description = "CIDR block for the spoke VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke_host_subnet_name" {
  description = "Name of the host subnet in the spoke"
  type        = string
  default     = "host-subnet"
}

variable "spoke_host_subnet_cidr" {
  description = "CIDR block for the host subnet in the spoke"
  type        = string
  default     = "10.0.1.0/24"
}

variable "spoke_container_subnet_name" {
  description = "Name of the container subnet in the spoke"
  type        = string
  default     = "container-subnet"
}

variable "spoke_container_subnet_cidr" {
  description = "CIDR block for the container subnet in the spoke"
  type        = string
  default     = "10.0.2.0/24"
}

variable "spoke_pe_subnet_name" {
  description = "Name of the Private Endpoint subnet in the spoke"
  type        = string
  default     = "spoke-pe-subnet"
}

variable "spoke_pe_subnet_cidr" {
  description = "CIDR block for the Private Endpoint subnet in the spoke"
  type        = string
  default     = "10.0.3.0/24"
}

variable "spoke_nsg_name" {
  description = "Name of the NSG for the spoke VNet"
  type        = string
  default     = "databricks-nsg"
}

###############################################################################
# Firewall Variables
###############################################################################

variable "firewall_name" {
  description = "Name of the Azure Firewall"
  type        = string
  default     = "afw-databricks"
}

variable "service_tag_rules" {
  description = "List of service tag rules for the firewall"
  type = list(object({
    name              = string
    priority          = number
    action            = string
    destination_tags  = list(string)
    destination_ports = list(string)
    protocols         = list(string)
  }))
  default = [{
    name              = "allow-databricks"
    priority          = 100
    action            = "Allow"
    destination_tags  = ["AzureDatabricks"]
    destination_ports = ["443"]
    protocols         = ["TCP"]
  }]
}

###############################################################################
# Private Endpoint Variables
###############################################################################

variable "workspace_resource_id" {
  description = "Resource ID of the Databricks workspace (from the blueprint layer)"
  type        = string
}
