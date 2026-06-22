# Azure NCC + Storage Networking Component

Network Connectivity Config for serverless compute combined with VNet injection for classic compute. This component sets up networking for both compute types in a single deployment, providing a unified networking foundation for workspaces that use both classic and serverless SQL warehouses or jobs.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `azure-account-network-connectivity-config` | Network Connectivity Config for serverless compute |
| `azure-account-network-vnet` | VNet, host subnet, container subnet, NSG for classic compute |

## Key Inputs

| Variable | Description | Default |
|----------|-------------|---------|
| `databricks_account_id` | Databricks account ID | — |
| `ncc_name` | Name of the NCC | — |
| `ncc_region` | Azure region for the NCC | — |
| `resource_group_name` | Azure resource group name | — |
| `location` | Azure region for VNet | — |
| `vnet_name` | Name of the VNet | — |
| `vnet_cidr` | CIDR for the VNet | `10.0.0.0/16` |
| `host_subnet_cidr` | Host subnet CIDR | `10.0.1.0/24` |
| `container_subnet_cidr` | Container subnet CIDR | `10.0.2.0/24` |
| `tags` | Resource tags | `{}` |

## Key Outputs

| Output | Description |
|--------|-------------|
| `ncc_id` | ID of the Network Connectivity Config |
| `ncc_name` | Name of the NCC |
| `vnet_id` | ID of the VNet |
| `host_subnet_id` | ID of the host subnet |
| `host_subnet_name` | Name of the host subnet |
| `container_subnet_id` | ID of the container subnet |
| `container_subnet_name` | Name of the container subnet |
| `nsg_id` | ID of the NSG |

## Usage Example

```hcl
module "ncc_storage" {
  source = "../networking/azure/ncc-storage"

  # NCC for serverless
  databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  ncc_name              = "ncc-prod-eastus2"
  ncc_region            = "eastus2"

  # VNet for classic compute
  resource_group_name   = "rg-databricks-prod"
  location              = "eastus2"
  vnet_name             = "vnet-databricks"
  vnet_cidr             = "10.0.0.0/16"
  host_subnet_cidr      = "10.0.1.0/24"
  container_subnet_cidr = "10.0.2.0/24"

  tags = {
    Environment = "production"
  }
}
```

## Notes

- The NCC is an account-level resource managed via the Databricks Account API. It must be attached to a workspace at the blueprint layer.
- The VNet provides classic compute networking (interactive clusters, classic jobs). Serverless compute uses the NCC for its network path.
- Typically `ncc_region` and `location` should be the same Azure region.
- The NCC enables features like private connectivity to storage accounts and stable egress IPs for serverless compute.
