# Azure Hub-Spoke Firewall (egress filtering, public front-end) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

resource_group_name = "my-databricks-rg"
location            = "eastus"

hub_vnet_name   = "my-hub-vnet"
spoke_vnet_name = "my-spoke-vnet"

# Optional — sensible defaults applied if omitted
# hub_vnet_cidr            = "10.1.0.0/16"
# hub_firewall_subnet_cidr = "10.1.0.0/26"
# hub_gateway_subnet_cidr  = "10.1.1.0/27"   # "" to skip the GatewaySubnet
# spoke_vnet_cidr          = "10.0.0.0/16"
# spoke_host_subnet_cidr   = "10.0.1.0/24"
# spoke_container_subnet_cidr = "10.0.2.0/24"
# firewall_name            = "afw-databricks"
# service_tag_rules default allows AzureDatabricks:443/TCP

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
