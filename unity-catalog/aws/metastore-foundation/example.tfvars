# AWS Unity Catalog Metastore Foundation — example variables
# Copy to terraform.tfvars (gitignored). Run ONCE per region.

metastore_name = "us-east-1-metastore"
region         = "us-east-1"

# RECOMMENDED: storageless (omit storage_root_url) — manage storage at the
# catalog level via domain-catalog. To attach a metastore storage root instead,
# set all of:
# storage_root_url     = "s3://my-uc-metastore-bucket/metastore"
# data_access_name     = "us-east-1-metastore-access"
# credential_name      = "uc-metastore-credential"
# role_name            = "uc-metastore-role"
# bucket_name          = "my-uc-metastore-bucket"
# aws_account_id       = "123456789012"
# aws_partition        = "aws"   # "aws-us-gov" for GovCloud (see docs/GOVCLOUD.md)
# databricks_gov_shard = null    # "civilian" | "dod"

# Optional — assign workspaces (label => workspace ID)
# workspace_ids = { prod = "1234567890123456" }
