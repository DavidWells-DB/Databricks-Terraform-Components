# GCP BYOVPC (customer-managed VPC + Cloud NAT) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

databricks_account_id = "00000000-0000-0000-0000-000000000000"
project_id            = "my-gcp-project"
region                = "us-central1"
resource_prefix       = "my-workspace"

# Optional — sensible defaults applied if omitted
# network_name                 = ""            # defaults to "<prefix>-vpc"
# network_cidr                 = "10.0.0.0/16"
# pod_secondary_range_cidr     = "10.1.0.0/16"
# service_secondary_range_cidr = "10.2.0.0/20"
