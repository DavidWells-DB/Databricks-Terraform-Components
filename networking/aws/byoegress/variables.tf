variable "existing_nat_gateway_ids" {
  type        = list(string)
  description = "Existing NAT gateway IDs used for private default routes."
  nullable    = false

  validation {
    condition     = length(var.existing_nat_gateway_ids) > 0 && alltrue([for id in var.existing_nat_gateway_ids : can(regex("^nat-[0-9a-f]+$", id))])
    error_message = "existing_nat_gateway_ids must contain at least one valid NAT gateway ID."
  }
}

variable "private_route_table_ids" {
  type        = map(string)
  description = "Map of stable caller keys to private route table IDs that default-route through the existing NAT gateways."
  nullable    = false

  validation {
    condition     = length(var.private_route_table_ids) > 0 && alltrue([for _, id in var.private_route_table_ids : can(regex("^rtb-[0-9a-f]+$", id))])
    error_message = "private_route_table_ids must contain at least one valid route table ID."
  }
}
