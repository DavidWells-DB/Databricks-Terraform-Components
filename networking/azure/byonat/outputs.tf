output "nat_gateway_id" {
  value       = data.azurerm_nat_gateway.this.id
  description = "Referenced NAT gateway ID."
}

output "nat_gateway_name" {
  value       = data.azurerm_nat_gateway.this.name
  description = "Referenced NAT gateway name."
}

output "public_ip_id" {
  value       = data.azurerm_public_ip.this.id
  description = "Referenced NAT public IP ID."
}

output "public_ip_address" {
  value       = data.azurerm_public_ip.this.ip_address
  description = "Referenced NAT public IP address."
}
