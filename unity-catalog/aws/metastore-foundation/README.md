# AWS Metastore Foundation

Creates the Unity Catalog metastore foundation for an AWS region. Run **once per region** by a platform team.

Defaults to a **storageless metastore** (recommended — manage storage at the catalog level via `domain-catalog`). A storageless, unassigned metastore is account-plane only and needs just the `databricks.account` provider.

## What It Creates

1. **Unity Catalog metastore** (always).
2. **AWS storage credential + data access** — only when `storage_root_url` is set. The `aws-uc-storage-credential` module creates the IAM role (with the UC trust policy); the S3 bucket must already exist.
3. **Workspace assignments** — only when `workspace_ids` is non-empty.

## Modules Composed

| Module | When |
|--------|------|
| `dbx-uc-metastore` | always |
| `aws-uc-storage-credential` | `storage_root_url` set |
| `dbx-uc-metastore-assignment` | `workspace_ids` non-empty |

## Providers

`databricks.account`, `databricks.workspace`, and `aws` (passed by the caller).

## Key Inputs

| Variable | Description | Required |
|----------|-------------|----------|
| `metastore_name` | Metastore name | Yes |
| `region` | AWS region | Yes |
| `storage_root_url` | S3 root (empty = storageless) | No |
| `data_access_name`, `credential_name`, `role_name`, `bucket_name`, `aws_account_id` | Storage credential inputs | When `storage_root_url` set |
| `aws_partition`, `databricks_gov_shard` | GovCloud — see [docs/GOVCLOUD.md](../../../docs/GOVCLOUD.md) | No |
| `workspace_ids` | label => workspace ID | No |

## Usage (storageless)

```hcl
module "metastore" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/aws/metastore-foundation?ref=main"

  providers = {
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
    aws                  = aws
  }

  metastore_name = "us-east-1-metastore"
  region         = "us-east-1"
}
```

See `example.tfvars` for the with-storage variant.
