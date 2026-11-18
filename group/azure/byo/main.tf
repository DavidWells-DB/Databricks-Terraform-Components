data "azurerm_resource_group" "this" {
  name = element(split("/", var.existing_resource_group_id), length(split("/", var.existing_resource_group_id)) - 1)

  lifecycle {
    postcondition {
      condition     = lower(self.location) == lower(var.location)
      error_message = "The existing resource group location must match the workspace location."
    }
  }
}
