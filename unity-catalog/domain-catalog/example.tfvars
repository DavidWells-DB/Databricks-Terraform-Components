# Unity Catalog Domain Catalog — example variables
# Copy to terraform.tfvars (gitignored) and fill in. Run once per team/env/domain.

cloud           = "aws" # aws | azure | gcp
metastore_id    = "00000000-0000-0000-0000-000000000000" # from metastore-foundation
catalog_name    = "marketing"
credential_name = "marketing-catalog-credential"

# Optional catalog config
# catalog_comment        = "Marketing domain catalog"
# catalog_storage_root   = ""        # empty = metastore default managed storage
# catalog_isolation_mode = "OPEN"    # OPEN | ISOLATED
# catalog_properties     = {}
# catalog_grants         = { "data-engineers" = ["ALL_PRIVILEGES"], "analysts" = ["USE_CATALOG"] }

# Schemas to create within the catalog
schemas = {
  bronze = {
    comment = "Raw ingested data"
    grants  = [{ principal = "data-engineers", privileges = ["ALL_PRIVILEGES"] }]
  }
  silver = {
    comment = "Cleansed data"
  }
}

# External locations (optional)
# external_locations = {
#   raw_data = {
#     url     = "s3://my-bucket/raw/"
#     comment = "Raw data location"
#     grants  = { "data-engineers" = ["ALL_PRIVILEGES"] }
#   }
# }

# --- AWS (when cloud = "aws") ---
aws_role_name   = "marketing-catalog-role"
aws_bucket_name = "my-marketing-bucket"
aws_account_id  = "123456789012"
# aws_partition       = "aws"
# databricks_gov_shard = false

# --- Azure (when cloud = "azure") ---
# azure_resource_group_name   = "my-uc-rg"
# azure_location              = "eastus"
# azure_storage_account_id    = "/subscriptions/.../storageAccounts/myaccount"
# azure_access_connector_name = "marketing-access-connector"

# --- GCP (when cloud = "gcp") ---
# gcp_bucket_name = "my-marketing-bucket"
