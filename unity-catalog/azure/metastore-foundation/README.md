# Azure Metastore Foundation

Creates the Unity Catalog metastore foundation for an Azure region. Run **once per region** by a platform team.

Defaults to a **storageless metastore** (recommended — manage storage at the catalog level via `domain-catalog`). A storageless, unassigned metastore is account-plane only and needs just the `databricks.account` provider.

## What It Creates

1. **Unity Catalog metastore** (always).
2. **Azure storage credential (access connector) + data access** — only when `storage_root_url` is set.
3. **Workspace assignments** — only when `workspace_ids` is non-empty.

## Modules Composed

| Module | When |
|--------|------|
| `dbx-uc-metastore` | always |
| `azure-uc-storage-credential` | `storage_root_url` set |
| `dbx-uc-metastore-assignment` | `workspace_ids` non-empty |

## Providers

`databricks.account`, `databricks.workspace`, and `azurerm` (passed by the caller).

## Key Inputs

| Variable | Description | Required |
|----------|-------------|----------|
| `metastore_name` | Metastore name | Yes |
| `region` | Azure region | Yes |
| `storage_root_url` | ADLS root (empty = storageless) | No |
| `data_access_name`, `credential_name`, `resource_group_name`, `location`, `storage_account_id`, `access_connector_name` | Storage credential inputs | When `storage_root_url` set |
| `workspace_ids` | label => workspace ID | No |

## Usage (storageless)

```hcl
module "metastore" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/azure/metastore-foundation?ref=main"

  providers = {
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
    azurerm              = azurerm
  }

  metastore_name = "eastus-metastore"
  region         = "eastus"
}
```

See `example.tfvars` for the with-storage variant.
