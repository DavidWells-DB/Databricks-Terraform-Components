# AWS Exfiltration Protection (hub-spoke + TGW + Network Firewall) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

databricks_account_id = "00000000-0000-0000-0000-000000000000"
region                = "us-east-1"
resource_prefix       = "my-workspace"

# Hub VPC (firewall + NAT) — defaults applied if omitted
# hub_vpc_cidr              = "10.0.0.0/16"
# hub_availability_zones    = ["us-east-1a", "us-east-1b"]
# hub_public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
# hub_firewall_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
# hub_private_subnet_cidrs  = ["10.0.5.0/24", "10.0.6.0/24"]

# Spoke VPC (Databricks workloads)
# spoke_vpc_cidr                 = "10.1.0.0/16"
# spoke_availability_zones       = ["us-east-1a", "us-east-1b"]
# spoke_private_subnet_cidrs     = ["10.1.1.0/24", "10.1.2.0/24"]
# spoke_privatelink_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]

# Transit Gateway / PrivateLink
# tgw_asn            = 64512
# enable_privatelink = true

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
