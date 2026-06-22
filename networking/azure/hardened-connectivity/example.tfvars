# Azure Hardened Connectivity (VNet injection + back-end Private Link) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

resource_group_name = "my-databricks-rg"
location            = "eastus"
vnet_name           = "my-databricks-vnet"

# Resource ID of the workspace (created in the blueprint layer) to attach the PE to:
workspace_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-databricks-rg/providers/Microsoft.Databricks/workspaces/my-workspace"

# Optional — sensible defaults applied if omitted
# vnet_cidr             = "10.0.0.0/16"
# host_subnet_cidr      = "10.0.1.0/24"
# container_subnet_cidr = "10.0.2.0/24"
# pe_subnet_cidr        = "10.0.3.0/24"
# nsg_name              = "databricks-nsg"

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
