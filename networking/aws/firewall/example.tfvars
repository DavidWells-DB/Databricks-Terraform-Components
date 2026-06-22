# AWS Firewall Networking — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

databricks_account_id = "00000000-0000-0000-0000-000000000000"
region                = "us-east-1"
resource_prefix       = "my-workspace"

# Optional — sensible defaults applied if omitted
# vpc_cidr              = "10.0.0.0/16"
# availability_zones    = ["us-east-1a", "us-east-1b"]
# private_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
# public_subnet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
# firewall_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]
# firewall_name         = "my-workspace-fw"
# Attach existing rule groups by ARN (otherwise a default policy is created):
# firewall_stateful_rule_group_arns  = []
# firewall_stateless_rule_group_arns = []
# databricks_gov_shard  = null

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
