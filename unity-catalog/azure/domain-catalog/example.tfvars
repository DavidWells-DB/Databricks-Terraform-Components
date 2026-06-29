# Azure Unity Catalog Domain Catalog — example variables
# Copy to terraform.tfvars (gitignored). Run once per team/env/domain.

metastore_id = "00000000-0000-0000-0000-000000000000" # from metastore-foundation
catalog_name = "finance"

schemas = {
  raw       = { comment = "Raw financial data" }
  reporting = { comment = "Reports", grants = [{ principal = "finance-analysts", privileges = ["USE_SCHEMA", "SELECT"] }] }
}

# External storage is OPTIONAL. To use a dedicated catalog root and/or external
# locations, set the storage-credential inputs:
# catalog_storage_root  = "abfss://finance@myaccount.dfs.core.windows.net/"
# credential_name       = "finance-catalog-credential"
# resource_group_name   = "my-uc-rg"
# location              = "eastus"
# storage_account_id    = "/subscriptions/.../storageAccounts/myaccount"
# access_connector_name = "finance-connector"
# external_locations = {
#   transactions = { url = "abfss://transactions@myaccount.dfs.core.windows.net/" }
# }
