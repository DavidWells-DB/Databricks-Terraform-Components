# Azure Hub-Spoke Firewall Networking Component

Hub-spoke topology with Azure Firewall for egress filtering, without Private Link. This is a simpler alternative to the `isolated` component for customers who need egress control but not full private connectivity. Users access the workspace over the public internet, but all data plane egress is forced through the firewall.

Corresponds to the **Hub-Spoke with Egress Firewall** pattern.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `azure-account-network-vnet` (hub) | Hub VNet with AzureFirewallSubnet and GatewaySubnet |
| `azure-account-network-vnet` (spoke) | Spoke VNet with host and container subnets |
| `azure-account-network-vnet-peering` | Bidirectional peering between hub and spoke |
| `azure-account-network-firewall` | Azure Firewall for egress filtering |

## Architecture

```
                    ┌──────────────────────────────┐
                    │          Hub VNet             │
Internet ──────────►│  ┌──────────┐ ┌──────────┐  │
                    │  │ Firewall │ │ Gateway  │  │
                    │  │  Subnet  │ │  Subnet  │  │
                    │  └──────────┘ └──────────┘  │
                    └──────────┬───────────────────┘
                               │ Peering
                    ┌──────────┴───────────────────┐
                    │         Spoke VNet            │
                    │  ┌────────┐   ┌──────────┐   │
                    │  │  Host  │   │Container │   │
                    │  │ Subnet │   │  Subnet  │   │
                    │  └────────┘   └──────────┘   │
                    └──────────────────────────────┘
```

## Key Inputs

| Variable | Description | Default |
|----------|-------------|---------|
| `resource_group_name` | Azure resource group name | — |
| `location` | Azure region | — |
| `hub_vnet_name` | Hub VNet name | — |
| `hub_vnet_cidr` | Hub VNet CIDR | `10.1.0.0/16` |
| `hub_firewall_subnet_cidr` | Firewall subnet CIDR | `10.1.0.0/26` |
| `hub_gateway_subnet_cidr` | Gateway subnet CIDR | `10.1.1.0/27` |
| `spoke_vnet_name` | Spoke VNet name | — |
| `spoke_vnet_cidr` | Spoke VNet CIDR | `10.0.0.0/16` |
| `spoke_host_subnet_cidr` | Host subnet CIDR | `10.0.1.0/24` |
| `spoke_container_subnet_cidr` | Container subnet CIDR | `10.0.2.0/24` |
| `firewall_name` | Azure Firewall name | `afw-databricks` |
| `service_tag_rules` | Firewall service tag rules | `[]` |
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
| `spoke_nsg_id` | NSG ID (spoke) |
| `firewall_private_ip` | Firewall private IP |
| `firewall_id` | Azure Firewall ID |

## Usage Example

```hcl
module "hub_spoke_firewall" {
  source = "../networking/azure/hub-spoke-firewall"

  resource_group_name = "rg-databricks-prod"
  location            = "eastus2"

  hub_vnet_name            = "vnet-hub"
  hub_vnet_cidr            = "10.1.0.0/16"
  hub_firewall_subnet_cidr = "10.1.0.0/26"
  hub_gateway_subnet_cidr  = "10.1.1.0/27"

  spoke_vnet_name             = "vnet-spoke-databricks"
  spoke_vnet_cidr             = "10.0.0.0/16"
  spoke_host_subnet_cidr      = "10.0.1.0/24"
  spoke_container_subnet_cidr = "10.0.2.0/24"

  firewall_name = "afw-databricks"

  service_tag_rules = [
    {
      name                  = "allow-databricks-control-plane"
      priority              = 100
      destination_addresses = ["AzureDatabricks"]
      destination_ports     = ["443"]
      protocols             = ["TCP"]
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

## Notes

- This component does NOT include Private Link. If you need Private Endpoints, use the `isolated` component instead.
- The firewall forces all spoke egress through itself via UDR. Configure `service_tag_rules` to allow required Databricks service traffic.
- The GatewaySubnet is provisioned in the hub for optional ExpressRoute or VPN Gateway connectivity.
