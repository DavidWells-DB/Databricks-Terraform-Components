# GCP Shared VPC Networking Component

Provisions a Shared VPC host project network with Cloud NAT and associates one or more service projects. The VPC and subnets are created in the host project, while Databricks workspaces are deployed in service projects that consume the shared network.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `gcp-account-network-vpc` | VPC with primary subnet and secondary ranges (host project) |
| `gcp-account-network-cloud-nat` | Cloud NAT gateway for outbound internet access |
| `gcp-account-network-shared-vpc` | Shared VPC host enablement and service project attachment |

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `databricks_account_id` | Databricks account ID | yes |
| `host_project_id` | GCP host project ID | yes |
| `service_project_ids` | List of service project IDs to attach | yes |
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
| `host_project_id` | Host project ID |
| `service_project_ids` | Attached service project IDs |

## Usage Example

```hcl
module "shared_vpc_network" {
  source = "path/to/networking/gcp/shared-vpc"

  databricks_account_id        = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  host_project_id              = "my-host-project"
  service_project_ids          = ["my-service-project-1", "my-service-project-2"]
  region                       = "us-central1"
  resource_prefix              = "my-workspace"
  network_cidr                 = "10.0.0.0/16"
  pod_secondary_range_cidr     = "10.1.0.0/16"
  service_secondary_range_cidr = "10.2.0.0/20"
}
```
