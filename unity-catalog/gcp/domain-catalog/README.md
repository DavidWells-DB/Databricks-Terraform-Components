# GCP Domain Catalog

Creates a domain/environment catalog (and its schemas) within an existing Unity Catalog metastore on GCP. Run **once per team, environment, or domain**.

## What It Creates

1. **Catalog + schemas** (always).
2. **GCP storage credential + external locations** — only when the catalog uses external storage (`external_locations` non-empty or `catalog_storage_root` set). A catalog on metastore-default managed storage needs no credential.

## Modules Composed

| Module | When |
|--------|------|
| `dbx-uc-catalog`, `dbx-uc-schema` | always |
| `dbx-uc-external-location` | always (no-op when `external_locations` empty) |
| `gcp-uc-storage-credential` | external storage used |

## Providers

`databricks.workspace` and `google` (passed by the caller).

## Key Inputs

| Variable | Description | Required |
|----------|-------------|----------|
| `metastore_id` | From metastore-foundation | Yes |
| `catalog_name` | Catalog name | Yes |
| `schemas`, `catalog_grants`, `catalog_comment`, `catalog_isolation_mode` | Catalog config | No |
| `catalog_storage_root`, `external_locations` | External storage | No |
| `credential_name`, `bucket_name` | Storage credential | When external storage used |

## Usage (minimal — metastore-default storage)

```hcl
module "catalog" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/gcp/domain-catalog?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
    google               = google
  }

  metastore_id = module.metastore.metastore_id
  catalog_name = "ml_platform"
  schemas      = { features = { comment = "Feature store" } }
}
```

See `example.tfvars` for the external-storage variant.
