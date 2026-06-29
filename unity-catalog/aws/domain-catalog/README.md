# AWS Domain Catalog

Creates a domain/environment catalog (and its schemas) within an existing Unity Catalog metastore on AWS. Run **once per team, environment, or domain**.

## What It Creates

1. **Catalog + schemas** (always).
2. **AWS storage credential + external locations** — only when the catalog uses external storage (`external_locations` non-empty or `catalog_storage_root` set). A catalog on metastore-default managed storage needs no credential.

## Modules Composed

| Module | When |
|--------|------|
| `dbx-uc-catalog`, `dbx-uc-schema` | always |
| `dbx-uc-external-location` | always (no-op when `external_locations` empty) |
| `aws-uc-storage-credential` | external storage used |

## Providers

`databricks.workspace` and `aws` (passed by the caller).

## Key Inputs

| Variable | Description | Required |
|----------|-------------|----------|
| `metastore_id` | From metastore-foundation | Yes |
| `catalog_name` | Catalog name | Yes |
| `schemas`, `catalog_grants`, `catalog_comment`, `catalog_isolation_mode` | Catalog config | No |
| `catalog_storage_root`, `external_locations` | External storage | No |
| `credential_name`, `role_name`, `bucket_name`, `aws_account_id` | Storage credential | When external storage used |
| `aws_partition`, `databricks_gov_shard` | GovCloud — see [docs/GOVCLOUD.md](../../../docs/GOVCLOUD.md) | No |

## Usage (minimal — metastore-default storage)

```hcl
module "catalog" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/aws/domain-catalog?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
    aws                  = aws
  }

  metastore_id = module.metastore.metastore_id
  catalog_name = "marketing"
  schemas      = { bronze = { comment = "Raw" }, gold = { comment = "Curated" } }
}
```

See `example.tfvars` for the external-storage variant.
