output "ncc_id" {
  description = "Network Connectivity Configuration ID"
  value       = module.ncc.network_connectivity_config_id
}

output "ncc_name" {
  description = "Network Connectivity Configuration name"
  value       = module.ncc.name
}

output "endpoint_service_name" {
  description = "VPC Endpoint Service name for the serverless PrivateLink"
  value       = module.serverless_privatelink.endpoint_service_name
}

output "endpoint_service_id" {
  description = "VPC Endpoint Service ID"
  value       = module.serverless_privatelink.endpoint_service_id
}

output "nlb_arn" {
  description = "ARN of the Network Load Balancer"
  value       = module.serverless_privatelink.nlb_arn
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = module.serverless_privatelink.nlb_dns_name
}
