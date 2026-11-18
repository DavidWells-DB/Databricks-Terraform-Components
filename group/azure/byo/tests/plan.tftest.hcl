mock_provider "azurerm" {
  mock_data "azurerm_resource_group" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/existing-rg"
      name     = "existing-rg"
      location = "eastus"
    }
  }
}

variables {
  existing_resource_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/existing-rg"
  location                   = "eastus"
}

run "references_existing_group_and_checks_region" {
  command = plan

  assert {
    condition     = output.id == var.existing_resource_group_id && output.name == "existing-rg"
    error_message = "The existing resource group must be returned without a create resource"
  }
}
