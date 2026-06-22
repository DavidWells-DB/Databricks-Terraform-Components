###############################################################################
# Databricks Outputs
###############################################################################

output "network_id" {
  description = "Databricks network configuration ID"
  value       = module.spoke_vpc.databricks_network_id
}

output "private_access_settings_id" {
  description = "Databricks private access settings ID (if PrivateLink enabled)"
  value       = var.enable_privatelink ? module.spoke_privatelink[0].private_access_settings_id : null
}

###############################################################################
# Hub VPC Outputs
###############################################################################

output "hub_vpc_id" {
  description = "ID of the hub VPC"
  value       = aws_vpc.hub.id
}

output "hub_firewall_arn" {
  description = "ARN of the hub Network Firewall"
  value       = module.hub_firewall.firewall_arn
}

###############################################################################
# Spoke VPC Outputs
###############################################################################

output "spoke_vpc_id" {
  description = "ID of the spoke VPC"
  value       = module.spoke_vpc.vpc_id
}

output "spoke_private_subnet_ids" {
  description = "Map of spoke private subnet IDs"
  value       = module.spoke_vpc.private_subnet_ids
}

output "spoke_security_group_id" {
  description = "ID of the spoke Databricks workspace security group"
  value       = module.spoke_vpc.security_group_id
}

output "spoke_privatelink_subnet_ids" {
  description = "Map of spoke PrivateLink subnet IDs (empty if PrivateLink disabled)"
  value       = module.spoke_vpc.privatelink_subnet_ids
}

###############################################################################
# Transit Gateway Outputs
###############################################################################

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = module.transit_gateway.transit_gateway_id
}

output "transit_gateway_hub_attachment_id" {
  description = "Transit Gateway attachment ID for the hub VPC"
  value       = module.transit_gateway.attachment_ids["hub"]
}

output "transit_gateway_spoke_attachment_id" {
  description = "Transit Gateway attachment ID for the spoke VPC"
  value       = module.transit_gateway.attachment_ids["spoke"]
}

###############################################################################
# PrivateLink Outputs
###############################################################################

output "workspace_vpc_endpoint_id" {
  description = "VPC endpoint ID for the workspace (REST API) endpoint"
  value       = var.enable_privatelink ? module.spoke_privatelink[0].workspace_vpc_endpoint_id : null
}

output "relay_vpc_endpoint_id" {
  description = "VPC endpoint ID for the relay (SCC) endpoint"
  value       = var.enable_privatelink ? module.spoke_privatelink[0].relay_vpc_endpoint_id : null
}
