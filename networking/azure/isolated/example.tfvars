# Azure Isolated (full Private Link + Azure Firewall, hub-spoke) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

resource_group_name = "my-databricks-rg"
location            = "eastus"

hub_vnet_name   = "my-hub-vnet"
spoke_vnet_name = "my-spoke-vnet"

# Resource ID of the workspace (created in the blueprint layer) for the private endpoints:
workspace_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-databricks-rg/providers/Microsoft.Databricks/workspaces/my-workspace"

# Optional — sensible defaults applied if omitted
# hub_vnet_cidr            = "10.1.0.0/16"
# hub_firewall_subnet_cidr = "10.1.0.0/26"
# hub_gateway_subnet_cidr  = "10.1.1.0/27"   # "" to skip the GatewaySubnet
# hub_pe_subnet_cidr       = "10.1.2.0/24"
# spoke_vnet_cidr          = "10.0.0.0/16"
# spoke_host_subnet_cidr   = "10.0.1.0/24"
# spoke_container_subnet_cidr = "10.0.2.0/24"
# spoke_pe_subnet_cidr     = "10.0.3.0/24"
# firewall_name            = "afw-databricks"

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
