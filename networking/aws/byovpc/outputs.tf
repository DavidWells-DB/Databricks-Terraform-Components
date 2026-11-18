# Same output contract as networking/aws/basic (Rule 8.4 — create and adopt expose
# the same interface; the blueprint selects one). Network outputs are real (the
# registrations are created here); the echo passthroughs carry the customer's
# existing IDs so downstream modules compose unchanged.

output "network_id" {
  description = "Databricks network configuration ID the workspace should use: the PrivateLink registration when enabled, otherwise base."
  value       = databricks_mws_networks.this[local.active_network].network_id
}

output "network_ids" {
  description = "Map of network config role (base / privatelink) to Databricks network ID. When PrivateLink is enabled both exist; 'base' is the retained, detached config left by the in-place cutover (harmless metadata)."
  value       = { for k, n in databricks_mws_networks.this : k => n.network_id }
}

output "vpc_id" {
  description = "The EXISTING VPC ID (echo passthrough)."
  value       = var.existing_vpc_id
}

output "private_subnet_ids" {
  description = "The EXISTING private subnet IDs (echo passthrough, same map shape as the input)."
  value       = var.existing_private_subnet_ids
}

output "privatelink_subnet_ids" {
  description = "The EXISTING PrivateLink subnet IDs (echo passthrough). Pass values(...) to aws-account-network-privatelink-endpoints.privatelink_subnet_ids."
  value       = var.existing_privatelink_subnet_ids
}

output "public_subnet_ids" {
  description = "The EXISTING public subnet IDs (echo passthrough). Pass values(...) to aws-account-network-egress-internet.public_subnet_ids."
  value       = var.existing_public_subnet_ids
}

output "private_route_table_ids" {
  description = "The EXISTING private route-table IDs (echo passthrough). Pass values(...) to egress/vpc-endpoints modules."
  value       = var.existing_private_route_table_ids
}

output "security_group_id" {
  description = "The security group for the Databricks registration: your first existing group when bringing your own, else the Databricks-required group this component creates in the BYO VPC."
  value       = var.existing_security_group_ids != null ? var.existing_security_group_ids[0] : aws_security_group.databricks[0].id
}

output "nat_gateway_ids" {
  description = "Empty by default; the Blueprint creates or adopts NAT separately for the existing-VPC path."
  value       = []
}
