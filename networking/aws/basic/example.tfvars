# AWS Basic Networking — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

databricks_account_id = "00000000-0000-0000-0000-000000000000"
region                = "us-east-1"
resource_prefix       = "my-workspace"

# Optional — sensible defaults applied if omitted.
# With only the required inputs above, the component auto-selects az_count AZs and
# derives one /20 private + one /24 public subnet per AZ from vpc_cidr. Override any of
# these to take manual control.
# vpc_cidr             = "10.0.0.0/16"
# az_count             = 2                                # AZs to span when availability_zones is unset (min 2)
# availability_zones   = ["us-east-1a", "us-east-1b"]
# private_subnet_cidrs = ["10.0.0.0/20", "10.0.16.0/20"]
# public_subnet_cidrs  = ["10.0.240.0/24", "10.0.241.0/24"]
# databricks_gov_shard = null  # null | "civilian" | "dod"

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
