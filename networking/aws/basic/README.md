# AWS Basic Networking Component

Provisions a standard Databricks-ready VPC with internet egress via NAT Gateway and essential VPC endpoints for S3, STS, and Kinesis Streams.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `aws-account-network-vpc` | VPC with private/public subnets and security groups |
| `aws-account-network-egress-internet` | Internet Gateway + NAT Gateway for outbound traffic |
| `aws-account-network-vpc-endpoints` | S3, STS, and Kinesis gateway/interface endpoints |

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `databricks_account_id` | Databricks account ID | yes |
| `region` | AWS region | yes |
| `resource_prefix` | Prefix for all resource names | yes |
| `vpc_cidr` | VPC CIDR block (default: `10.0.0.0/16`) | no |
| `availability_zones` | AZs to use | no |
| `private_subnet_cidrs` | Private subnet CIDRs | no |
| `public_subnet_cidrs` | Public subnet CIDRs | no |
| `databricks_gov_shard` | GovCloud shard (`null`, `"civilian"`, or `"dod"`) | no |
| `tags` | Resource tags | no |

## Key Outputs

| Name | Description |
|------|-------------|
| `network_id` | Databricks MWS network configuration ID |
| `vpc_id` | VPC ID |
| `private_subnet_ids` | Private subnet ID map |
| `security_group_id` | Workspace security group ID |

## Usage Example

```hcl
module "basic_network" {
  source = "path/to/networking/aws/basic"

  databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  region                = "us-east-1"
  resource_prefix       = "my-workspace"
  vpc_cidr              = "10.0.0.0/16"

  tags = {
    Environment = "production"
  }
}
```
