# AWS Firewall Networking Component

Provisions a Databricks-ready VPC with AWS Network Firewall for egress filtering, enabling fine-grained control over outbound traffic from workspace clusters.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `aws-account-network-vpc` | VPC with private, public, and firewall subnets |
| `aws-account-network-egress-internet` | Internet Gateway + NAT Gateway |
| `aws-account-network-vpc-endpoints` | S3, STS, and Kinesis endpoints |
| `aws-account-network-firewall` | AWS Network Firewall with egress filtering |

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `databricks_account_id` | Databricks account ID | yes |
| `region` | AWS region | yes |
| `resource_prefix` | Prefix for all resource names | yes |
| `vpc_cidr` | VPC CIDR block (default: `10.0.0.0/16`) | no |
| `firewall_subnet_cidrs` | CIDR blocks for firewall subnets | no |
| `firewall_stateful_rule_group_arns` | Stateful rule group ARNs | no |
| `firewall_stateless_rule_group_arns` | Stateless rule group ARNs | no |
| `firewall_allow_domains` | Domains to allow through firewall | no |
| `databricks_gov_shard` | GovCloud shard (`null`/`"civilian"`/`"dod"`) — see [GovCloud support](../../../docs/GOVCLOUD.md) | no |
| `tags` | Resource tags | no |

## Key Outputs

| Name | Description |
|------|-------------|
| `network_id` | Databricks MWS network configuration ID |
| `vpc_id` | VPC ID |
| `firewall_arn` | AWS Network Firewall ARN |
| `firewall_endpoint_ids` | Firewall endpoint IDs per AZ |
| `security_group_id` | Workspace security group ID |

## Usage Example

```hcl
module "firewall_network" {
  source = "path/to/networking/aws/firewall"

  databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  region                = "us-east-1"
  resource_prefix       = "my-workspace"
  vpc_cidr              = "10.0.0.0/16"

  firewall_allow_domains = [
    ".pypi.org",
    ".pythonhosted.org",
    ".cran.r-project.org",
  ]

  tags = {
    Environment = "production"
  }
}
```
