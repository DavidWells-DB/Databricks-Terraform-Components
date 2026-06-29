# AWS Unity Catalog Domain Catalog — example variables
# Copy to terraform.tfvars (gitignored). Run once per team/env/domain.

metastore_id = "00000000-0000-0000-0000-000000000000" # from metastore-foundation
catalog_name = "marketing"

schemas = {
  bronze = { comment = "Raw ingested data" }
  gold   = { comment = "Curated" }
}

# External storage is OPTIONAL — a catalog on metastore-default managed storage
# needs no credential. To use a dedicated catalog root and/or external locations,
# set the storage-credential inputs:
# catalog_storage_root = "s3://my-marketing-bucket/catalog/"
# credential_name      = "marketing-catalog-credential"
# role_name            = "marketing-catalog-role"
# bucket_name          = "my-marketing-bucket"
# aws_account_id       = "123456789012"
# aws_partition        = "aws"   # "aws-us-gov" for GovCloud
# databricks_gov_shard = null    # "civilian" | "dod"
# external_locations = {
#   raw = { url = "s3://my-marketing-bucket/raw/", grants = { "data-engineers" = ["ALL_PRIVILEGES"] } }
# }
