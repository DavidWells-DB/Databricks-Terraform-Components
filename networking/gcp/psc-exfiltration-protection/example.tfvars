# GCP PSC Exfiltration Protection (hub-spoke + PSC + deny-all egress) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

databricks_account_id = "00000000-0000-0000-0000-000000000000"
project_id            = "my-gcp-project"
region                = "us-central1"
resource_prefix       = "my-workspace"

# Optional — sensible defaults applied if omitted
# spoke_network_cidr           = "10.0.0.0/16"
# pod_secondary_range_cidr     = "10.1.0.0/16"
# service_secondary_range_cidr = "10.2.0.0/20"
# hub_network_cidr             = "10.3.0.0/24"
# psc_subnet_cidr              = "10.3.1.0/24"
# google_apis_cidr             = "199.36.153.4/30"  # restricted.googleapis.com
# public_access_enabled        = false
