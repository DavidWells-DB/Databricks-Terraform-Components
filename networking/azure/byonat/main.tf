data "azurerm_nat_gateway" "this" {
  name                = element(split("/", var.existing_nat_gateway_id), length(split("/", var.existing_nat_gateway_id)) - 1)
  resource_group_name = split("/", var.existing_nat_gateway_id)[4]

  lifecycle {
    postcondition {
      condition     = lower(self.location) == lower(var.location)
      error_message = "The existing NAT gateway location must match the workspace location."
    }
  }
}

data "azurerm_public_ip" "this" {
  name                = element(split("/", var.existing_public_ip_id), length(split("/", var.existing_public_ip_id)) - 1)
  resource_group_name = split("/", var.existing_public_ip_id)[4]
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.subnets

  subnet_id      = each.value
  nat_gateway_id = data.azurerm_nat_gateway.this.id
}
