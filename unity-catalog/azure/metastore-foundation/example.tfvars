# Azure Unity Catalog Metastore Foundation — example variables
# Copy to terraform.tfvars (gitignored). Run ONCE per region.

metastore_name = "eastus-metastore"
region         = "eastus"

# RECOMMENDED: storageless (omit storage_root_url). To attach a metastore root:
# storage_root_url      = "abfss://metastore@myaccount.dfs.core.windows.net/"
# data_access_name      = "eastus-metastore-access"
# credential_name       = "uc-metastore-credential"
# resource_group_name   = "my-uc-rg"
# location              = "eastus"
# storage_account_id    = "/subscriptions/.../resourceGroups/my-uc-rg/providers/Microsoft.Storage/storageAccounts/myaccount"
# access_connector_name = "uc-access-connector"

# Optional — assign workspaces (label => workspace ID)
# workspace_ids = { prod = "1234567890123456" }
