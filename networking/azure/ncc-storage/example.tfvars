# Azure NCC + Storage (serverless NCC + classic VNet injection) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

# Toggle each half independently (both default true). For serverless-only set
# enable_vnet = false; for classic-only set enable_ncc = false.
# enable_ncc  = true
# enable_vnet = true

# NCC (required when enable_ncc = true)
databricks_account_id = "00000000-0000-0000-0000-000000000000"
ncc_name              = "my-workspace-ncc"
ncc_region            = "eastus"

# VNet (required when enable_vnet = true)
resource_group_name = "my-databricks-rg"
location            = "eastus"
vnet_name           = "my-databricks-vnet"

# Optional — sensible defaults applied if omitted
# vnet_cidr             = "10.0.0.0/16"
# host_subnet_cidr      = "10.0.1.0/24"
# container_subnet_cidr = "10.0.2.0/24"
# nsg_name              = "databricks-nsg"

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
