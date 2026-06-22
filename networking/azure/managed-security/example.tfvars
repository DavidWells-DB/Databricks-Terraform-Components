# Azure Managed Security (VNet injection + SCC/No Public IP) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

resource_group_name = "my-databricks-rg"
location            = "eastus"
vnet_name           = "my-databricks-vnet"

# Optional — sensible defaults applied if omitted
# vnet_cidr             = "10.0.0.0/16"
# host_subnet_name      = "host-subnet"
# host_subnet_cidr      = "10.0.1.0/24"
# container_subnet_name = "container-subnet"
# container_subnet_cidr = "10.0.2.0/24"
# nsg_name              = "databricks-nsg"

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
