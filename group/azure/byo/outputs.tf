output "id" {
  value       = data.azurerm_resource_group.this.id
  description = "Referenced resource-group ARM ID."
}

output "name" {
  value       = data.azurerm_resource_group.this.name
  description = "Referenced resource-group name."
}

output "location" {
  value       = data.azurerm_resource_group.this.location
  description = "Referenced resource-group location."
}
