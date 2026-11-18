resource "azurerm_resource_group" "this" {
  name     = coalesce(var.resource_group_name, "${var.resource_prefix}-rg")
  location = var.location
  tags     = var.tags
}
