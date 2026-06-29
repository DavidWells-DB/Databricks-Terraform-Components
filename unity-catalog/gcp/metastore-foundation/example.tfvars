# GCP Unity Catalog Metastore Foundation — example variables
# Copy to terraform.tfvars (gitignored). Run ONCE per region.

metastore_name = "us-central1-metastore"
region         = "us-central1"

# RECOMMENDED: storageless (omit storage_root_url). To attach a metastore root:
# storage_root_url = "gs://my-uc-metastore-bucket/metastore"
# data_access_name = "us-central1-metastore-access"
# credential_name  = "uc-metastore-credential"
# bucket_name      = "my-uc-metastore-bucket"

# Optional — assign workspaces (label => workspace ID)
# workspace_ids = { prod = "1234567890123456" }
