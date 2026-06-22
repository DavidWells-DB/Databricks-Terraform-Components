# AWS Exfiltration Protection Networking Component

Implements a hub-spoke network architecture using AWS Transit Gateway with Network Firewall in the hub for egress filtering, providing defense-in-depth against data exfiltration. The spoke VPC hosts Databricks workloads with optional PrivateLink for secure control plane connectivity.

## Architecture

```
                    Internet
                       |
                   [IGW/NAT]
                       |
              +--------+--------+
              |    Hub VPC      |
              | [Network FW]    |
              +--------+--------+
                       |
              [Transit Gateway]
                       |
              +--------+--------+
              |   Spoke VPC     |
              | [Databricks]    |
              | [VPC Endpoints] |
              | [PrivateLink]   |
              +-----------------+
```

## Modules Composed

| Module | Purpose |
|--------|---------|
| `aws-account-network-vpc` (x2) | Hub and Spoke VPCs |
| `aws-account-network-egress-internet` | Hub IGW + NAT Gateway |
| `aws-account-network-firewall` | Hub Network Firewall |
| `aws-account-network-vpc-endpoints` | Spoke S3/STS/Kinesis endpoints |
| `aws-account-network-privatelink-endpoints` | Spoke PrivateLink (optional) |
| `aws-account-network-transit-gateway` | Hub-Spoke connectivity |

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `databricks_account_id` | Databricks account ID | yes |
| `region` | AWS region | yes |
| `resource_prefix` | Prefix for all resource names | yes |
| `hub_vpc_cidr` | Hub VPC CIDR (default: `10.0.0.0/16`) | no |
| `spoke_vpc_cidr` | Spoke VPC CIDR (default: `10.1.0.0/16`) | no |
| `hub_firewall_subnet_cidrs` | Hub firewall subnet CIDRs | no |
| `spoke_private_subnet_cidrs` | Spoke private subnet CIDRs | no |
| `spoke_privatelink_subnet_cidrs` | Spoke PrivateLink subnet CIDRs | no |
| `enable_privatelink` | Enable PrivateLink endpoints (default: `true`) | no |
| `tgw_asn` | Transit Gateway BGP ASN (default: `64512`) | no |
| `firewall_allow_domains` | Domains to allow through firewall | no |
| `databricks_gov_shard` | GovCloud shard | no |
| `tags` | Resource tags | no |

## Key Outputs

| Name | Description |
|------|-------------|
| `network_id` | Databricks MWS network configuration ID |
| `hub_vpc_id` | Hub VPC ID |
| `spoke_vpc_id` | Spoke VPC ID |
| `transit_gateway_id` | Transit Gateway ID |
| `hub_firewall_arn` | Network Firewall ARN |
| `private_access_settings_id` | Private access settings ID (if PrivateLink enabled) |

## Usage Example

```hcl
module "exfiltration_protection" {
  source = "path/to/networking/aws/exfiltration-protection"

  databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  region                = "us-east-1"
  resource_prefix       = "my-workspace"

  hub_vpc_cidr              = "10.0.0.0/16"
  hub_public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  hub_firewall_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  hub_private_subnet_cidrs  = ["10.0.5.0/24", "10.0.6.0/24"]

  spoke_vpc_cidr                 = "10.1.0.0/16"
  spoke_private_subnet_cidrs     = ["10.1.1.0/24", "10.1.2.0/24"]
  spoke_privatelink_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]

  enable_privatelink = true

  firewall_allow_domains = [
    ".pypi.org",
    ".pythonhosted.org",
  ]

  tags = {
    Environment = "production"
    Security    = "high"
  }
}
```
