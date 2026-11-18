mock_provider "azurerm" {
  mock_data "azurerm_nat_gateway" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/natGateways/existing-nat"
      name     = "existing-nat"
      location = "eastus"
    }
  }

  mock_data "azurerm_public_ip" {
    defaults = {
      id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/publicIPAddresses/existing-ip"
      ip_address = "203.0.113.10"
    }
  }
}

variables {
  existing_nat_gateway_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/natGateways/existing-nat"
  existing_public_ip_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/publicIPAddresses/existing-ip"
  location                = "eastus"
  subnets = {
    host      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/host"
    container = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/container"
  }
}

run "creates_only_subnet_associations" {
  command = plan

  assert {
    condition     = length(azurerm_subnet_nat_gateway_association.this) == 2
    error_message = "Both selected subnets must be associated with the existing NAT gateway"
  }
  assert {
    condition     = output.nat_gateway_id == var.existing_nat_gateway_id && output.public_ip_address == "203.0.113.10"
    error_message = "Existing NAT and public IP attributes must be returned"
  }
}
