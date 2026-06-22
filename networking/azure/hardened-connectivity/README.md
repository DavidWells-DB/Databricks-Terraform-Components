# Azure Hardened Connectivity Networking Component

VNet injection with back-end Private Link. This tier adds private endpoints for the data plane (back-end connectivity) while keeping front-end access over the public internet. Users connect to the workspace UI publicly, but cluster-to-control-plane traffic goes over Private Link.

Corresponds to the **Private Link (back-end only)** pattern in Microsoft's documentation.

## Modules Composed

| Module | Purpose |
|--------|---------|
| `azure-account-network-vnet` | VNet, host subnet, container subnet, PE subnet, NSG |
| `azure-account-network-private-endpoints` | Back-end Private Endpoint + Private DNS Zone |

## Key Inputs

| Variable | Description | Default |
|----------|-------------|---------|
| `resource_group_name` | Azure resource group name | — |
| `location` | Azure region | — |
| `vnet_name` | Name of the VNet | — |
| `vnet_cidr` | CIDR for the VNet | `10.0.0.0/16` |
| `host_subnet_cidr` | Host subnet CIDR | `10.0.1.0/24` |
| `container_subnet_cidr` | Container subnet CIDR | `10.0.2.0/24` |
| `pe_subnet_cidr` | Private Endpoint subnet CIDR | `10.0.3.0/24` |
| `workspace_resource_id` | Databricks workspace resource ID | — |
| `tags` | Resource tags | `{}` |

## Key Outputs

| Output | Description |
|--------|-------------|
| `vnet_id` | ID of the VNet |
| `host_subnet_id` | ID of the host subnet |
| `host_subnet_name` | Name of the host subnet |
| `container_subnet_id` | ID of the container subnet |
| `container_subnet_name` | Name of the container subnet |
| `pe_subnet_id` | ID of the PE subnet |
| `nsg_id` | ID of the NSG |
| `backend_pe_id` | ID of the back-end Private Endpoint |
| `private_dns_zone_id` | ID of the Private DNS Zone |

## Usage Example

```hcl
module "hardened_connectivity" {
  source = "../networking/azure/hardened-connectivity"

  resource_group_name   = "rg-databricks-prod"
  location              = "eastus2"
  vnet_name             = "vnet-databricks"
  vnet_cidr             = "10.0.0.0/16"
  host_subnet_cidr      = "10.0.1.0/24"
  container_subnet_cidr = "10.0.2.0/24"
  pe_subnet_cidr        = "10.0.3.0/24"
  workspace_resource_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Databricks/workspaces/my-workspace"

  tags = {
    Environment = "production"
  }
}
```

## Notes

- The `workspace_resource_id` input comes from the blueprint layer. The Databricks workspace must be created before private endpoints can be provisioned against it.
- Front-end Private Endpoints and browser authentication PEs are explicitly disabled in this tier. Use the `isolated` component for full Private Link.
