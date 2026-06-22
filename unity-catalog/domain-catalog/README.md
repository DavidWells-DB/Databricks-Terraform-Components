# Domain Catalog

Creates a domain or environment-specific catalog within an existing Unity Catalog metastore. This component is intended to be run **many times** - once per team, environment, or data domain.

## What It Creates

1. **Storage Credential** - Cloud-specific credential for this domain's storage (AWS IAM Role, Azure Access Connector, or GCP Service Account)
2. **External Locations** - Registered storage paths using the credential
3. **Catalog** - A Unity Catalog catalog with configurable isolation and grants
4. **Schemas** - Schemas within the catalog (e.g., bronze, silver, gold)

## Modules Composed

| Module | Source |
|--------|--------|
| `aws-uc-storage-credential` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-uc-storage-credential?ref=v1.0.0` |
| `azure-uc-storage-credential` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-uc-storage-credential?ref=v1.0.0` |
| `gcp-uc-storage-credential` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-uc-storage-credential?ref=v1.0.0` |
| `dbx-uc-external-location` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-external-location?ref=v1.0.0` |
| `dbx-uc-catalog` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-catalog?ref=v1.0.0` |
| `dbx-uc-schema` | `github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-schema?ref=v1.0.0` |

## Cross-Cloud Usage

This component works across all three clouds. Set the `cloud` variable to select which storage credential module to activate. Only the provider for the selected cloud needs to be configured, though all three are declared in `versions.tf`.

## Key Inputs

| Variable | Description | Required |
|----------|-------------|----------|
| `cloud` | Cloud provider: `aws`, `azure`, or `gcp` | Yes |
| `metastore_id` | Metastore ID from metastore-foundation | Yes |
| `catalog_name` | Name of the catalog to create | Yes |
| `credential_name` | Name for the storage credential | Yes |
| `schemas` | Map of schema names to config | No |
| `external_locations` | Map of location names to config | No |
| `catalog_comment` | Description for the catalog | No |
| `catalog_storage_root` | Managed storage root for the catalog | No |
| `catalog_grants` | Grants map (principal => privileges) | No |
| `aws_*` | AWS-specific variables (when `cloud = "aws"`) | Conditional |
| `azure_*` | Azure-specific variables (when `cloud = "azure"`) | Conditional |
| `gcp_*` | GCP-specific variables (when `cloud = "gcp"`) | Conditional |

## Key Outputs

| Output | Description |
|--------|-------------|
| `storage_credential_id` | ID of the storage credential |
| `catalog_name` | Name of the created catalog |
| `external_location_ids` | Map of location names to IDs |
| `aws_iam_role_arn` | (AWS) IAM role ARN |
| `azure_access_connector_id` | (Azure) Access connector ID |
| `gcp_service_account_email` | (GCP) Service account email |

## Usage Examples

### AWS

```hcl
module "engineering_catalog" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/domain-catalog?ref=v1.0.0"

  cloud        = "aws"
  metastore_id = module.metastore_foundation.metastore_id
  catalog_name = "engineering"

  # Storage credential
  credential_name = "engineering-credential"
  aws_role_name   = "databricks-uc-engineering-role"
  aws_bucket_name = "engineering-data-bucket"
  aws_account_id  = "123456789012"

  # External locations
  external_locations = {
    raw_data = {
      url     = "s3://engineering-data-bucket/raw/"
      comment = "Raw ingested data"
    }
    curated_data = {
      url     = "s3://engineering-data-bucket/curated/"
      comment = "Curated datasets"
    }
  }

  # Catalog configuration
  catalog_comment = "Engineering team data catalog"
  catalog_grants = {
    "engineering-team" = ["USE_CATALOG", "USE_SCHEMA", "SELECT"]
    "data-admins"      = ["ALL_PRIVILEGES"]
  }

  # Schemas
  schemas = {
    bronze = {
      comment = "Raw ingested data"
      grants = {
        "data-engineers" = ["ALL_PRIVILEGES"]
      }
    }
    silver = {
      comment = "Cleaned and transformed data"
      grants = {
        "data-engineers" = ["ALL_PRIVILEGES"]
        "data-analysts"  = ["USE_SCHEMA", "SELECT"]
      }
    }
    gold = {
      comment = "Business-ready aggregations"
      grants = {
        "data-engineers" = ["ALL_PRIVILEGES"]
        "data-analysts"  = ["USE_SCHEMA", "SELECT"]
        "bi-users"       = ["USE_SCHEMA", "SELECT"]
      }
    }
  }
}
```

### Azure

```hcl
module "finance_catalog" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/domain-catalog?ref=v1.0.0"

  cloud        = "azure"
  metastore_id = module.metastore_foundation.metastore_id
  catalog_name = "finance"

  # Storage credential
  credential_name             = "finance-credential"
  azure_resource_group_name   = "rg-databricks-finance"
  azure_location              = "eastus"
  azure_storage_account_id    = "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/financestorage"
  azure_access_connector_name = "finance-uc-connector"

  # External locations
  external_locations = {
    transactions = {
      url     = "abfss://transactions@financestorage.dfs.core.windows.net/"
      comment = "Transaction data"
    }
  }

  # Catalog configuration
  catalog_comment    = "Finance domain catalog"
  catalog_isolation_mode = "ISOLATED"
  catalog_grants = {
    "finance-team" = ["USE_CATALOG", "USE_SCHEMA", "SELECT"]
    "data-admins"  = ["ALL_PRIVILEGES"]
  }

  # Schemas
  schemas = {
    raw = {
      comment = "Raw financial data"
    }
    reporting = {
      comment = "Financial reports and aggregations"
      grants = {
        "finance-analysts" = ["USE_SCHEMA", "SELECT"]
      }
    }
  }
}
```

### GCP

```hcl
module "ml_catalog" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/domain-catalog?ref=v1.0.0"

  cloud        = "gcp"
  metastore_id = module.metastore_foundation.metastore_id
  catalog_name = "ml_platform"

  # Storage credential
  credential_name = "ml-platform-credential"
  gcp_bucket_name = "ml-platform-data"

  # External locations
  external_locations = {
    training_data = {
      url     = "gs://ml-platform-data/training/"
      comment = "ML training datasets"
    }
    model_artifacts = {
      url       = "gs://ml-platform-data/models/"
      comment   = "Model artifacts and checkpoints"
      read_only = true
    }
  }

  # Catalog configuration
  catalog_comment = "Machine Learning platform catalog"
  catalog_grants = {
    "ml-engineers" = ["USE_CATALOG", "USE_SCHEMA", "SELECT", "MODIFY"]
    "data-admins"  = ["ALL_PRIVILEGES"]
  }

  # Schemas
  schemas = {
    features = {
      comment = "Feature store tables"
    }
    experiments = {
      comment = "Experiment tracking data"
    }
    production = {
      comment = "Production model serving data"
      grants = {
        "ml-engineers"    = ["ALL_PRIVILEGES"]
        "service-accounts" = ["USE_SCHEMA", "SELECT"]
      }
    }
  }
}
```
