# Unity Catalog Metastore Foundation — example variables
# Copy to terraform.tfvars (gitignored) and fill in. Run ONCE per region.
# Set `cloud` and fill in the matching cloud-specific block below.

cloud          = "aws" # aws | azure | gcp
metastore_name = "us-east-1-metastore"
region         = "us-east-1"

# RECOMMENDED: leave storage_root_url empty (default) for a storageless
# metastore — manage storage at the catalog level via domain-catalog. In that
# case data_access_name and the cloud storage-credential inputs below are not
# needed, and the metastore is created at the account plane only.
#
# To attach a metastore-level storage root (discouraged), set both:
# data_access_name = "us-east-1-metastore-access"
# storage_root_url for the metastore root:
#   aws:   s3://my-uc-metastore-bucket/metastore
#   azure: abfss://metastore@myaccount.dfs.core.windows.net/
#   gcp:   gs://my-uc-metastore-bucket/metastore
# storage_root_url = "s3://my-uc-metastore-bucket/metastore"

# Optional — assign workspaces to the metastore (label => workspace ID)
# workspace_ids = { prod = "1234567890123456" }

# --- AWS (only when cloud = "aws" AND storage_root_url is set) ---
# aws_credential_name  = "uc-metastore-credential"
# aws_role_name        = "uc-metastore-role"
# aws_bucket_name      = "my-uc-metastore-bucket"
# aws_account_id       = "123456789012"
# aws_partition        = "aws"          # or "aws-us-gov"
# databricks_gov_shard = false

# --- Azure (when cloud = "azure") ---
# azure_credential_name       = "uc-metastore-credential"
# azure_resource_group_name   = "my-uc-rg"
# azure_location              = "eastus"
# azure_storage_account_id    = "/subscriptions/.../storageAccounts/myaccount"
# azure_access_connector_name = "uc-access-connector"

# --- GCP (when cloud = "gcp") ---
# gcp_credential_name = "uc-metastore-credential"
# gcp_bucket_name     = "my-uc-metastore-bucket"
