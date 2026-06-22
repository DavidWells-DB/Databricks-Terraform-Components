# AWS Serverless PrivateLink Networking Component

Enables Databricks serverless compute (SQL Warehouses, Model Serving, Notebooks, etc.) to securely connect to customer-managed services via AWS PrivateLink. Creates a Network Connectivity Configuration (NCC) and provisions an NLB + VPC Endpoint Service that Databricks serverless infrastructure can connect to.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `aws-account-network-connectivity-config` | Databricks Network Connectivity Configuration |
| `aws-account-network-serverless-privatelink` | NLB + VPC Endpoint Service for serverless connectivity |

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `databricks_account_id` | Databricks account ID | yes |
| `region` | AWS region | yes |
| `resource_prefix` | Prefix for all resource names | yes |
| `vpc_id` | VPC ID for the NLB | yes |
| `subnet_ids` | Subnet IDs for NLB targets | yes |
| `target_ip` | IP of the target service | yes |
| `target_port` | Port of the target service | yes |
| `aws_partition` | AWS partition (default: `aws`) | no |
| `databricks_gov_shard` | GovCloud shard | no |
| `tags` | Resource tags | no |

## Key Outputs

| Name | Description |
|------|-------------|
| `ncc_id` | Network Connectivity Configuration ID |
| `vpc_endpoint_service_name` | VPC Endpoint Service name |
| `vpc_endpoint_service_id` | VPC Endpoint Service ID |
| `nlb_arn` | Network Load Balancer ARN |
| `nlb_dns_name` | NLB DNS name |

## Usage Example

```hcl
module "serverless_privatelink" {
  source = "path/to/networking/aws/serverless-privatelink"

  databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  region                = "us-east-1"
  resource_prefix       = "my-service"

  vpc_id     = "vpc-0123456789abcdef0"
  subnet_ids = ["subnet-abc123", "subnet-def456"]
  target_ip  = "10.0.1.100"
  target_port = 443

  tags = {
    Environment = "production"
    Service     = "customer-api"
  }
}
```
