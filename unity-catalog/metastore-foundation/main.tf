# -----------------------------------------------------------------------------
# Metastore Foundation Component
# -----------------------------------------------------------------------------
# This component creates the Unity Catalog metastore foundation:
# 1. Unity Catalog metastore (always)
# 2. Cloud-specific storage credential + data access (only when storage_root_url is set)
# 3. Metastore-to-workspace assignments (only when workspace_ids is non-empty)
#
# With no storage_root_url and no workspace_ids, this creates a storageless
# metastore at the account plane only (recommended; manage storage at the
# catalog level via the domain-catalog component).
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Cloud-Specific Storage Credentials (only one will be active)
# -----------------------------------------------------------------------------

module "aws_storage_credential" {
  count  = (local.create_storage && var.cloud == "aws") ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-uc-storage-credential?ref=aws-uc-storage-credential/v0.1.0"

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
  count  = (local.create_storage && var.cloud == "azure") ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-uc-storage-credential?ref=azure-uc-storage-credential/v0.1.0"

  providers = {
    databricks.workspace = databricks.workspace
  }

  resource_group_name   = var.azure_resource_group_name
  location              = var.azure_location
  storage_account_id    = var.azure_storage_account_id
  credential_name       = var.azure_credential_name
  access_connector_name = var.azure_access_connector_name
}

module "gcp_storage_credential" {
  count  = (local.create_storage && var.cloud == "gcp") ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-uc-storage-credential?ref=gcp-uc-storage-credential/v0.1.0"

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
  # When storage_root_url is empty, create a storageless metastore: skip the
  # cloud storage-credential modules and pass no credential to the metastore.
  create_storage = var.storage_root_url != ""

  storage_credential_id = local.create_storage ? coalesce(
    var.cloud == "aws" ? try(module.aws_storage_credential[0].storage_credential_id, "") : "",
    var.cloud == "azure" ? try(module.azure_storage_credential[0].storage_credential_id, "") : "",
    var.cloud == "gcp" ? try(module.gcp_storage_credential[0].storage_credential_id, "") : "",
  ) : null

  storage_credential = local.create_storage ? (
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
      aws_iam_role                   = null
      azure_managed_identity         = null
      databricks_gcp_service_account = {}
    }
  ) : null
}

# -----------------------------------------------------------------------------
# Unity Catalog Metastore
# -----------------------------------------------------------------------------

module "metastore" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-metastore?ref=dbx-uc-metastore/v0.1.0"

  providers = {
    databricks.account = databricks.account
  }

  metastore_name     = var.metastore_name
  region             = var.region
  storage_root_url   = local.create_storage ? var.storage_root_url : null
  data_access_name   = local.create_storage ? var.data_access_name : null
  storage_credential = local.storage_credential
}

# -----------------------------------------------------------------------------
# Metastore-to-Workspace Assignment
# -----------------------------------------------------------------------------

module "metastore_assignment" {
  # Only assign when workspace_ids are provided; a metastore can be created
  # independently and assigned to workspaces later.
  count  = length(var.workspace_ids) > 0 ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-metastore-assignment?ref=dbx-uc-metastore-assignment/v0.1.0"

  providers = {
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
  }

  metastore_id  = module.metastore.metastore_id
  workspace_ids = var.workspace_ids
}
