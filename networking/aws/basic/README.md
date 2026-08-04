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
| `az_count` | AZs to span when `availability_zones` is unset (default `2`, min `2`) | no |
| `availability_zones` | AZs to use; empty = auto-select first `az_count` in region | no |
| `private_subnet_cidrs` | Private subnet CIDRs; empty = one `/20` per AZ from `vpc_cidr` | no |
| `public_subnet_cidrs` | Public subnet CIDRs; empty = one `/24` per AZ from `vpc_cidr` | no |
| `vpc_endpoint_ids` | Back-end PrivateLink endpoint IDs `{rest_api_id, relay_id}` to register into `mws_networks`; null = no PrivateLink | no |
| `privatelink_subnet_cidrs` | Dedicated PrivateLink subnet CIDRs; empty = one `/24` per AZ from `vpc_cidr` when `vpc_endpoint_ids` is set | no |
| `databricks_gov_shard` | GovCloud shard: `null`, `"civilian"`, or `"dod"` — see [GovCloud support](../../../docs/GOVCLOUD.md) | no |
| `tags` | Resource tags | no |

## Key Outputs

| Name | Description |
|------|-------------|
| `network_id` | Databricks MWS network configuration ID |
| `vpc_id` | VPC ID |
| `private_subnet_ids` | Private subnet ID map |
| `privatelink_subnet_ids` | PrivateLink subnet ID map (empty unless back-end PrivateLink is used) |
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

The three required inputs are sufficient: with `availability_zones`, `private_subnet_cidrs`, and `public_subnet_cidrs` all omitted, the component auto-selects `az_count` AZs and derives one `/20` private + one `/24` public subnet per AZ from `vpc_cidr`. Supply any of them to take manual control.
