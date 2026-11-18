variable "existing_nat_gateway_id" {
  type        = string
  description = "Full ARM ID of an existing NAT gateway."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/natGateways/[^/]+$", var.existing_nat_gateway_id))
    error_message = "existing_nat_gateway_id must be a full NAT gateway ARM ID."
  }
}

variable "existing_public_ip_id" {
  type        = string
  description = "Full ARM ID of an existing public IP associated with the NAT gateway."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/publicIPAddresses/[^/]+$", var.existing_public_ip_id))
    error_message = "existing_public_ip_id must be a full public IP ARM ID."
  }
}

variable "location" {
  type        = string
  description = "Required workspace location. The NAT gateway must be in this region."
  nullable    = false
}

variable "subnets" {
  type        = map(string)
  description = "Map of stable caller keys to existing or newly created subnet IDs that should use the NAT gateway."
  nullable    = false

  validation {
    condition     = length(var.subnets) > 0
    error_message = "At least one subnet association is required."
  }
}
