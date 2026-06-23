# Metastore Foundation

Creates the Unity Catalog metastore foundation for a region. This component is intended to be run **once per region** by a platform team.

## What It Creates

1. **Unity Catalog Metastore** - The metastore itself (always created).
2. **Storage Credential + data access** - Cloud-specific credential for the metastore root (AWS IAM Role, Azure Access Connector, or GCP Service Account). Created **only when `storage_root_url` is set**. Leave it empty for a **storageless metastore** (recommended — manage storage at the catalog level via the `domain-catalog` component).
3. **Workspace Assignments** - Created **only when `workspace_ids` is non-empty**. A metastore can be created independently and assigned to workspaces later.

> **Storageless is the recommended default.** A metastore-level storage root is discouraged by current Databricks guidance; prefer catalog-level managed storage. A storageless metastore is also purely account-plane (no workspace-plane storage credential), so it needs only the `databricks.account` provider.

## Modules Composed

| Module | Source |
|--------|--------|
| `aws-uc-storage-credential` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-uc-storage-credential?ref=v1.0.0` |
| `azure-uc-storage-credential` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-uc-storage-credential?ref=v1.0.0` |
| `gcp-uc-storage-credential` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-uc-storage-credential?ref=v1.0.0` |
| `dbx-uc-metastore` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-metastore?ref=v1.0.0` |
| `dbx-uc-metastore-assignment` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-metastore-assignment?ref=v1.0.0` |

## Cross-Cloud Usage

This component works across all three clouds. Set the `cloud` variable to select which storage credential module to activate. Only the provider for the selected cloud needs to be configured, though all three are declared in `versions.tf`.

For **AWS GovCloud**, set `databricks_gov_shard` (`"civilian"` / `"dod"`) and `aws_partition = "aws-us-gov"`. See [GovCloud support](../../docs/GOVCLOUD.md).

## Key Inputs

| Variable | Description | Required |
|----------|-------------|----------|
| `cloud` | Cloud provider: `aws`, `azure`, or `gcp` | Yes |
| `metastore_name` | Name of the metastore | Yes |
| `region` | Cloud region for the metastore | Yes |
| `storage_root_url` | Root storage URL. Empty (default) = storageless metastore | No |
| `data_access_name` | Name for the data access configuration. Required only when `storage_root_url` is set | Conditional |
| `workspace_ids` | Map of label => workspace_id for assignment (empty = no assignment) | No |
| `aws_*` | AWS-specific variables (when `cloud = "aws"`) | Conditional |
| `azure_*` | Azure-specific variables (when `cloud = "azure"`) | Conditional |
| `gcp_*` | GCP-specific variables (when `cloud = "gcp"`) | Conditional |

## Key Outputs

| Output | Description |
|--------|-------------|
| `metastore_id` | ID of the created metastore |
| `storage_credential_id` | ID of the storage credential |
| `assignment_ids` | Map of workspace labels to assignment IDs |
| `aws_iam_role_arn` | (AWS) IAM role ARN |
| `azure_access_connector_id` | (Azure) Access connector ID |
| `gcp_service_account_email` | (GCP) Service account email |

## Usage Examples

### Storageless (recommended)

Account-plane only — no storage credential, no workspace required. Manage storage at the catalog level via `domain-catalog`.

```hcl
module "metastore_foundation" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/metastore-foundation?ref=v1.0.0"

  providers = {
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace # declared but unused when storageless + unassigned
  }

  cloud          = "aws" # or azure / gcp
  metastore_name = "us-east-1-metastore"
  region         = "us-east-1"
  # storage_root_url omitted -> storageless
  # workspace_ids omitted    -> no assignment
}
```

### AWS

```hcl
module "metastore_foundation" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/metastore-foundation?ref=v1.0.0"

  cloud            = "aws"
  metastore_name   = "us-east-1-metastore"
  region           = "us-east-1"
  storage_root_url = "s3://my-metastore-bucket/unity-catalog"
  data_access_name = "metastore-root-credential"

  # AWS-specific
  aws_credential_name = "metastore-root-credential"
  aws_role_name       = "databricks-uc-metastore-role"
  aws_bucket_name     = "my-metastore-bucket"
  aws_account_id      = "123456789012"

  # Workspace assignments
  workspace_ids = {
    engineering = "1234567890"
    analytics   = "0987654321"
  }
}
```

### Azure

```hcl
module "metastore_foundation" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/metastore-foundation?ref=v1.0.0"

  cloud            = "azure"
  metastore_name   = "eastus-metastore"
  region           = "eastus"
  storage_root_url = "abfss://unity-catalog@mystorageaccount.dfs.core.windows.net/"
  data_access_name = "metastore-root-credential"

  # Azure-specific
  azure_credential_name       = "metastore-root-credential"
  azure_resource_group_name   = "rg-databricks-uc"
  azure_location              = "eastus"
  azure_storage_account_id    = "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
  azure_access_connector_name = "databricks-uc-connector"

  # Workspace assignments
  workspace_ids = {
    engineering = "1234567890"
    analytics   = "0987654321"
  }
}
```

### GCP

```hcl
module "metastore_foundation" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/metastore-foundation?ref=v1.0.0"

  cloud            = "gcp"
  metastore_name   = "us-central1-metastore"
  region           = "us-central1"
  storage_root_url = "gs://my-metastore-bucket/unity-catalog"
  data_access_name = "metastore-root-credential"

  # GCP-specific
  gcp_credential_name = "metastore-root-credential"
  gcp_bucket_name     = "my-metastore-bucket"

  # Workspace assignments
  workspace_ids = {
    engineering = "1234567890"
    analytics   = "0987654321"
  }
}
```
