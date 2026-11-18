variable "existing_vnet_id" {
  type        = string
  description = "Full resource ID of an existing VNet. The VNet and its Databricks subnets remain caller-owned."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+$", var.existing_vnet_id))
    error_message = "existing_vnet_id must be a full Azure VNet resource ID."
  }
}

variable "existing_host_subnet_id" {
  type        = string
  description = "Full resource ID of the existing delegated host/public subnet."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+/subnets/[^/]+$", var.existing_host_subnet_id)) && startswith(lower(var.existing_host_subnet_id), lower("${var.existing_vnet_id}/subnets/"))
    error_message = "existing_host_subnet_id must be a subnet in existing_vnet_id."
  }
}

variable "existing_container_subnet_id" {
  type        = string
  description = "Full resource ID of the existing delegated container/private subnet."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+/subnets/[^/]+$", var.existing_container_subnet_id)) && startswith(lower(var.existing_container_subnet_id), lower("${var.existing_vnet_id}/subnets/"))
    error_message = "existing_container_subnet_id must be a subnet in existing_vnet_id."
  }
}

variable "existing_host_subnet_nsg_association_id" {
  type        = string
  description = "Resource ID of the existing host-subnet NSG association. Required by the workspace VNet-injection contract."
  nullable    = false
}

variable "existing_container_subnet_nsg_association_id" {
  type        = string
  description = "Resource ID of the existing container-subnet NSG association. Required by the workspace VNet-injection contract."
  nullable    = false
}

variable "existing_pe_subnet_id" {
  type        = string
  description = "Optional existing private-endpoint subnet ID. It must belong to the same VNet and have private-endpoint network policies disabled."
  default     = null

  validation {
    condition     = var.existing_pe_subnet_id == null || (can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+/subnets/[^/]+$", var.existing_pe_subnet_id)) && startswith(lower(var.existing_pe_subnet_id), lower("${var.existing_vnet_id}/subnets/")))
    error_message = "existing_pe_subnet_id must be null or a subnet in existing_vnet_id."
  }
}
