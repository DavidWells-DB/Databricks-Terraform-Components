# GCP PSC Exfiltration Protection Component

Provisions a hub-spoke network architecture with Private Service Connect (PSC) endpoints for secure connectivity to the Databricks control plane, combined with deny-all egress firewall rules to prevent data exfiltration. All traffic to Databricks flows through PSC endpoints rather than the public internet.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `gcp-account-network-vpc` | Spoke VPC for Databricks workspace nodes |
| `gcp-account-network-psc-endpoints` | PSC endpoints, private access settings, and DNS zone |

## Inline Resources

| Resource | Purpose |
|----------|---------|
| `google_compute_network` | Hub VPC hosting PSC endpoints |
| `google_compute_subnetwork` | Hub subnet and PSC subnet |
| `google_compute_network_peering` | Hub-to-spoke and spoke-to-hub peering |
| `google_compute_firewall` | Deny-all egress + allow rules for Google APIs, PSC, and intra-VPC |

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `databricks_account_id` | Databricks account ID | yes |
| `project_id` | GCP project ID | yes |
| `region` | GCP region | yes |
| `resource_prefix` | Prefix for all resource names | yes |
| `spoke_network_cidr` | Spoke VPC subnet CIDR (default: `10.0.0.0/16`) | no |
| `pod_secondary_range_cidr` | GKE pod CIDR (default: `10.1.0.0/16`) | no |
| `service_secondary_range_cidr` | GKE service CIDR (default: `10.2.0.0/20`) | no |
| `hub_network_cidr` | Hub VPC subnet CIDR (default: `10.3.0.0/24`) | no |
| `psc_subnet_cidr` | PSC endpoint subnet CIDR (default: `10.3.1.0/24`) | no |
| `public_access_enabled` | Enable public workspace access (default: `false`) | no |

## Key Outputs

| Name | Description |
|------|-------------|
| `databricks_network_id` | Databricks network configuration ID |
| `spoke_network_self_link` | Spoke VPC self-link |
| `hub_network_self_link` | Hub VPC self-link |
| `private_access_settings_id` | Databricks private access settings ID |
| `workspace_psc_ip` | Workspace PSC endpoint IP |
| `relay_psc_ip` | Relay PSC endpoint IP |

## Usage Example

```hcl
module "psc_network" {
  source = "path/to/networking/gcp/psc-exfiltration-protection"

  databricks_account_id        = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  project_id                   = "my-gcp-project"
  region                       = "us-central1"
  resource_prefix              = "my-workspace"
  spoke_network_cidr           = "10.0.0.0/16"
  pod_secondary_range_cidr     = "10.1.0.0/16"
  service_secondary_range_cidr = "10.2.0.0/20"
  hub_network_cidr             = "10.3.0.0/24"
  psc_subnet_cidr              = "10.3.1.0/24"
  public_access_enabled        = false
}
```
