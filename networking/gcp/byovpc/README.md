# GCP BYOVPC Networking Component

Provisions a customer-managed VPC with Cloud NAT for outbound internet egress. This is the standard networking pattern for Databricks workspaces on GCP where the customer retains full control over the VPC configuration.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `gcp-account-network-vpc` | VPC with primary subnet and secondary ranges for GKE pods/services |
| `gcp-account-network-cloud-nat` | Cloud NAT gateway for outbound internet access |

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `databricks_account_id` | Databricks account ID | yes |
| `project_id` | GCP project ID | yes |
| `region` | GCP region | yes |
| `resource_prefix` | Prefix for all resource names | yes |
| `network_name` | Custom VPC name (defaults to `<prefix>-vpc`) | no |
| `network_cidr` | Primary subnet CIDR (default: `10.0.0.0/16`) | no |
| `pod_secondary_range_cidr` | GKE pod CIDR (default: `10.1.0.0/16`) | no |
| `service_secondary_range_cidr` | GKE service CIDR (default: `10.2.0.0/20`) | no |

## Key Outputs

| Name | Description |
|------|-------------|
| `network_self_link` | VPC network self-link |
| `subnetwork_self_link` | Workspace subnet self-link |
| `databricks_network_id` | Databricks network configuration ID |
| `network_cidr` | Primary CIDR block |
| `cloud_nat_ip` | Cloud NAT external IP |

## Usage Example

```hcl
module "byovpc" {
  source = "path/to/networking/gcp/byovpc"

  databricks_account_id        = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  project_id                   = "my-gcp-project"
  region                       = "us-central1"
  resource_prefix              = "my-workspace"
  network_cidr                 = "10.0.0.0/16"
  pod_secondary_range_cidr     = "10.1.0.0/16"
  service_secondary_range_cidr = "10.2.0.0/20"
}
```
