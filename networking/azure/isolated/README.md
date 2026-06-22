# Azure Isolated Networking Component

Full Private Link + Azure Firewall + Hub-Spoke topology. This is the most restrictive networking tier for Databricks on Azure — all traffic (front-end, back-end, and browser authentication) traverses Private Link, and egress from the data plane is forced through Azure Firewall.

Corresponds to the **No Public Access (Full Private Link + Firewall)** pattern.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `azure-account-network-vnet` (hub) | Hub VNet with AzureFirewallSubnet, GatewaySubnet, PE subnet |
| `azure-account-network-vnet` (spoke) | Spoke VNet with host subnet, container subnet, PE subnet |
| `azure-account-network-vnet-peering` | Bidirectional peering between hub and spoke |
| `azure-account-network-firewall` | Azure Firewall for egress filtering |
| `azure-account-network-private-endpoints` (hub) | Front-end + browser auth Private Endpoints |
| `azure-account-network-private-endpoints` (spoke) | Back-end Private Endpoint |

## Architecture

```
                    ┌─────────────────────────────────┐
                    │           Hub VNet               │
                    │  ┌──────────┐ ┌──────────────┐  │
Internet ──────────►│  │ Firewall │ │ PE Subnet    │  │
(blocked for        │  └──────────┘ │ (FE + Auth)  │  │
 workspace access)  │               └──────────────┘  │
                    └────────────┬────────────────────┘
                                 │ Peering
                    ┌────────────┴────────────────────┐
                    │          Spoke VNet              │
                    │  ┌────────┐ ┌──────────┐ ┌───┐  │
                    │  │  Host  │ │Container │ │PE │  │
                    │  │ Subnet │ │  Subnet  │ │Sub│  │
                    │  └────────┘ └──────────┘ └───┘  │
                    └─────────────────────────────────┘
```

## Key Inputs

| Variable | Description | Default |
|----------|-------------|---------|
| `resource_group_name` | Azure resource group name | — |
| `location` | Azure region | — |
| `hub_vnet_name` | Hub VNet name | — |
| `hub_vnet_cidr` | Hub VNet CIDR | `10.1.0.0/16` |
| `hub_firewall_subnet_cidr` | Firewall subnet CIDR | `10.1.0.0/26` |
| `hub_pe_subnet_cidr` | Hub PE subnet CIDR | `10.1.2.0/24` |
| `spoke_vnet_name` | Spoke VNet name | — |
| `spoke_vnet_cidr` | Spoke VNet CIDR | `10.0.0.0/16` |
| `spoke_host_subnet_cidr` | Spoke host subnet CIDR | `10.0.1.0/24` |
| `spoke_container_subnet_cidr` | Spoke container subnet CIDR | `10.0.2.0/24` |
| `spoke_pe_subnet_cidr` | Spoke PE subnet CIDR | `10.0.3.0/24` |
| `firewall_name` | Azure Firewall name | `afw-databricks` |
| `service_tag_rules` | Firewall service tag rules | `[]` |
| `workspace_resource_id` | Databricks workspace resource ID | — |
| `tags` | Resource tags | `{}` |

## Key Outputs

| Output | Description |
|--------|-------------|
| `hub_vnet_id` | Hub VNet ID |
| `spoke_vnet_id` | Spoke VNet ID |
| `host_subnet_id` | Host subnet ID (spoke) |
| `host_subnet_name` | Host subnet name (spoke) |
| `container_subnet_id` | Container subnet ID (spoke) |
| `container_subnet_name` | Container subnet name (spoke) |
| `spoke_pe_subnet_id` | PE subnet ID (spoke) |
| `firewall_private_ip` | Firewall private IP |
| `frontend_pe_id` | Front-end PE ID |
| `browser_auth_pe_id` | Browser auth PE ID |
| `backend_pe_id` | Back-end PE ID |
| `private_dns_zone_id` | Private DNS Zone ID |

## Usage Example

```hcl
module "isolated" {
  source = "../networking/azure/isolated"

  resource_group_name = "rg-databricks-prod"
  location            = "eastus2"

  hub_vnet_name            = "vnet-hub"
  hub_vnet_cidr            = "10.1.0.0/16"
  hub_firewall_subnet_cidr = "10.1.0.0/26"
  hub_pe_subnet_cidr       = "10.1.2.0/24"

  spoke_vnet_name          = "vnet-spoke-databricks"
  spoke_vnet_cidr          = "10.0.0.0/16"
  spoke_host_subnet_cidr   = "10.0.1.0/24"
  spoke_container_subnet_cidr = "10.0.2.0/24"
  spoke_pe_subnet_cidr     = "10.0.3.0/24"

  firewall_name         = "afw-databricks"
  workspace_resource_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Databricks/workspaces/my-workspace"

  tags = {
    Environment = "production"
    Security    = "high"
  }
}
```

## Notes

- The `workspace_resource_id` must be provided from the blueprint layer after the workspace is created.
- The firewall forces all spoke egress through itself via UDR. Configure `service_tag_rules` to allow Databricks control plane traffic.
- Front-end and browser auth PEs are deployed in the hub PE subnet; back-end PE is in the spoke PE subnet.
- For environments where the hub VNet already exists, consider using the `hub-spoke-firewall` component with separate PE provisioning.
