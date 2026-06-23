# AWS Multi-Workspace PrivateLink Networking Component

Provisions a shared VPC with backend PrivateLink connectivity (REST API + Secure Cluster Connectivity relay) that can be shared across multiple Databricks workspaces. Includes NAT Gateway for outbound internet access and standard VPC endpoints.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `aws-account-network-vpc` | VPC with private, public, and PrivateLink subnets |
| `aws-account-network-egress-internet` | Internet Gateway + NAT Gateway |
| `aws-account-network-vpc-endpoints` | S3, STS, and Kinesis endpoints |
| `aws-account-network-privatelink-endpoints` | Workspace + Relay PrivateLink endpoints |

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `databricks_account_id` | Databricks account ID | yes |
| `region` | AWS region | yes |
| `resource_prefix` | Prefix for all resource names | yes |
| `vpc_cidr` | VPC CIDR block (default: `10.0.0.0/16`) | no |
| `private_subnet_cidrs` | Private subnet CIDRs | no |
| `public_subnet_cidrs` | Public subnet CIDRs | no |
| `privatelink_subnet_cidrs` | PrivateLink subnet CIDRs | no |
| `security_group_ingress_cidr_blocks` | CIDRs allowed to access PrivateLink endpoints | no |
| `databricks_gov_shard` | GovCloud shard (`null`/`"civilian"`/`"dod"`) — see [GovCloud support](../../../docs/GOVCLOUD.md) | no |
| `tags` | Resource tags | no |

## Key Outputs

| Name | Description |
|------|-------------|
| `network_id` | Databricks MWS network configuration ID |
| `vpc_id` | VPC ID |
| `private_access_settings_id` | Private access settings ID |
| `workspace_vpc_endpoint_id` | Workspace REST API VPC endpoint ID |
| `relay_vpc_endpoint_id` | Relay SCC VPC endpoint ID |
| `security_group_id` | Workspace security group ID |

## Usage Example

```hcl
module "multi_workspace_privatelink" {
  source = "path/to/networking/aws/multi-workspace-privatelink"

  databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  region                = "us-east-1"
  resource_prefix       = "shared-network"
  vpc_cidr              = "10.0.0.0/16"

  private_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs      = ["10.0.3.0/24", "10.0.4.0/24"]
  privatelink_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]

  # Allow access from workspace VPCs via peering
  security_group_ingress_cidr_blocks = [
    "10.0.0.0/16",   # This VPC
    "10.1.0.0/16",   # Workspace VPC 1
    "10.2.0.0/16",   # Workspace VPC 2
  ]

  tags = {
    Environment = "production"
    SharedService = "true"
  }
}
```
