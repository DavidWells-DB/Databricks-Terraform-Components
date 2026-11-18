mock_provider "azurerm" {
  mock_data "azurerm_virtual_network" {
    defaults = {
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/existing-vnet"
      name = "existing-vnet"
    }
  }

  mock_data "azurerm_subnet" {
    defaults = {
      network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/networkSecurityGroups/existing-nsg"
    }
  }
}

variables {
  existing_vnet_id                             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/existing-vnet"
  existing_host_subnet_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/existing-vnet/subnets/host"
  existing_container_subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/existing-vnet/subnets/container"
  existing_host_subnet_nsg_association_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/existing-vnet/subnets/host"
  existing_container_subnet_nsg_association_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/existing-vnet/subnets/container"
}

override_data {
  target = data.azurerm_subnet.host
  values = {
    id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/existing-vnet/subnets/host"
    name                      = "host"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/networkSecurityGroups/existing-nsg"
  }
}

override_data {
  target = data.azurerm_subnet.container
  values = {
    id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/existing-vnet/subnets/container"
    name                      = "container"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/networkSecurityGroups/existing-nsg"
  }
}

run "returns_create_twin_output_contract" {
  command = plan

  assert {
    condition     = output.vnet_name == "existing-vnet" && output.host_subnet_name == "host" && output.container_subnet_name == "container"
    error_message = "The adopt twin must expose the network and subnet names"
  }
  assert {
    condition     = output.host_subnet_nsg_association_id == var.existing_host_subnet_nsg_association_id && output.container_subnet_nsg_association_id == var.existing_container_subnet_nsg_association_id
    error_message = "The required NSG association IDs must pass through"
  }
  assert {
    condition     = output.nsg_name == "existing-nsg"
    error_message = "The NSG name must be read from the existing subnet"
  }
}

run "rejects_subnet_from_another_vnet" {
  command = plan

  variables {
    existing_host_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/other-vnet/subnets/host"
  }

  expect_failures = [var.existing_host_subnet_id]
}
