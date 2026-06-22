# Azure Managed Security Networking Component

VNet injection with Secure Cluster Connectivity (No Public IP). This is the simplest networking tier for Databricks on Azure — it deploys a VNet with host and container subnets plus the required NSG rules.

Corresponds to Microsoft's **Secure Cluster Connectivity** pattern.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `azure-account-network-vnet` | VNet, host subnet, container subnet, optional PE subnet, NSG with associations |

## Key Inputs

| Variable | Description | Default |
|----------|-------------|---------|
| `resource_group_name` | Azure resource group name | — |
| `location` | Azure region | — |
| `vnet_name` | Name of the VNet | — |
| `vnet_cidr` | CIDR for the VNet | `10.0.0.0/16` |
| `host_subnet_name` | Host subnet name | `host-subnet` |
| `host_subnet_cidr` | Host subnet CIDR | `10.0.1.0/24` |
| `container_subnet_name` | Container subnet name | `container-subnet` |
| `container_subnet_cidr` | Container subnet CIDR | `10.0.2.0/24` |
| `nsg_name` | NSG name | `databricks-nsg` |
| `tags` | Resource tags | `{}` |

## Key Outputs

| Output | Description |
|--------|-------------|
| `vnet_id` | ID of the VNet |
| `host_subnet_id` | ID of the host subnet |
| `host_subnet_name` | Name of the host subnet |
| `container_subnet_id` | ID of the container subnet |
| `container_subnet_name` | Name of the container subnet |
| `nsg_id` | ID of the NSG |

## Usage Example

```hcl
module "managed_security" {
  source = "../networking/azure/managed-security"

  resource_group_name = "rg-databricks-prod"
  location            = "eastus2"
  vnet_name           = "vnet-databricks"
  vnet_cidr           = "10.0.0.0/16"
  host_subnet_cidr    = "10.0.1.0/24"
  container_subnet_cidr = "10.0.2.0/24"

  tags = {
    Environment = "production"
  }
}
```

## Notes

- **NAT Gateway**: A NAT Gateway module is not yet available in the upstream modules repo. If you need a NAT Gateway for stable outbound IPs, add one separately using the `azurerm_nat_gateway` resource and associate it with the host and container subnets. A dedicated module will be added when available.
- This component provides the network infrastructure only. The Databricks workspace itself is deployed at the blueprint layer using the outputs from this component.
