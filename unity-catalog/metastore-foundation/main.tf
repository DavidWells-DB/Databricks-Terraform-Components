# -----------------------------------------------------------------------------
# Metastore Foundation Component
# -----------------------------------------------------------------------------
# This component creates the Unity Catalog metastore foundation:
# 1. Cloud-specific storage credential (AWS, Azure, or GCP)
# 2. Unity Catalog metastore
# 3. Metastore-to-workspace assignments
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Cloud-Specific Storage Credentials (only one will be active)
# -----------------------------------------------------------------------------

module "aws_storage_credential" {
  count  = var.cloud == "aws" ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-uc-storage-credential?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
  }

  credential_name      = var.aws_credential_name
  role_name            = var.aws_role_name
  bucket_name          = var.aws_bucket_name
  aws_account_id       = var.aws_account_id
  aws_partition        = var.aws_partition
  databricks_gov_shard = var.databricks_gov_shard
}

module "azure_storage_credential" {
  count  = var.cloud == "azure" ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-uc-storage-credential?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
  }

  resource_group_name  = var.azure_resource_group_name
  location             = var.azure_location
  storage_account_id   = var.azure_storage_account_id
  credential_name      = var.azure_credential_name
  access_connector_name = var.azure_access_connector_name
}

module "gcp_storage_credential" {
  count  = var.cloud == "gcp" ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-uc-storage-credential?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
  }

  credential_name = var.gcp_credential_name
  bucket_name     = var.gcp_bucket_name
}

# -----------------------------------------------------------------------------
# Locals - Resolve the active storage credential ID
# -----------------------------------------------------------------------------

locals {
  storage_credential_id = coalesce(
    var.cloud == "aws" ? try(module.aws_storage_credential[0].storage_credential_id, "") : "",
    var.cloud == "azure" ? try(module.azure_storage_credential[0].storage_credential_id, "") : "",
    var.cloud == "gcp" ? try(module.gcp_storage_credential[0].storage_credential_id, "") : "",
  )

  storage_credential = (
    var.cloud == "aws" ? {
      aws_iam_role = {
        role_arn = try(module.aws_storage_credential[0].iam_role_arn, "")
      }
      azure_managed_identity         = null
      databricks_gcp_service_account = null
    } : var.cloud == "azure" ? {
      aws_iam_role = null
      azure_managed_identity = {
        access_connector_id = try(module.azure_storage_credential[0].access_connector_id, "")
      }
      databricks_gcp_service_account = null
    } : {
      aws_iam_role           = null
      azure_managed_identity = null
      databricks_gcp_service_account = {}
    }
  )
}

# -----------------------------------------------------------------------------
# Unity Catalog Metastore
# -----------------------------------------------------------------------------

module "metastore" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-metastore?ref=main"

  providers = {
    databricks.account = databricks.account
  }

  metastore_name     = var.metastore_name
  region             = var.region
  storage_root_url   = var.storage_root_url
  data_access_name   = var.data_access_name
  storage_credential = local.storage_credential
}

# -----------------------------------------------------------------------------
# Metastore-to-Workspace Assignment
# -----------------------------------------------------------------------------

module "metastore_assignment" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-metastore-assignment?ref=main"

  providers = {
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
  }

  metastore_id  = module.metastore.metastore_id
  workspace_ids = var.workspace_ids
}
