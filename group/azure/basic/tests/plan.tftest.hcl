mock_provider "azurerm" {}

variables {
  resource_prefix = "acme"
  location        = "eastus"
}

run "generated_name_preserves_default" {
  command = plan

  assert {
    condition     = azurerm_resource_group.this.name == "acme-rg"
    error_message = "The default resource-group name must remain prefix-derived"
  }
}

run "explicit_name_selects_named_creation" {
  command = plan

  variables {
    resource_group_name = "customer-rg"
  }

  assert {
    condition     = azurerm_resource_group.this.name == "customer-rg"
    error_message = "An explicit resource-group name must be used exactly"
  }
}
