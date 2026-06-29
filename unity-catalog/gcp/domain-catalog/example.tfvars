# GCP Unity Catalog Domain Catalog — example variables
# Copy to terraform.tfvars (gitignored). Run once per team/env/domain.

metastore_id = "00000000-0000-0000-0000-000000000000" # from metastore-foundation
catalog_name = "ml_platform"

schemas = {
  features    = { comment = "Feature store tables" }
  experiments = { comment = "Experiment tracking" }
}

# External storage is OPTIONAL. To use a dedicated catalog root and/or external
# locations, set the storage-credential inputs:
# catalog_storage_root = "gs://ml-platform-data/catalog/"
# credential_name      = "ml-platform-credential"
# bucket_name          = "ml-platform-data"
# external_locations = {
#   training = { url = "gs://ml-platform-data/training/" }
# }
