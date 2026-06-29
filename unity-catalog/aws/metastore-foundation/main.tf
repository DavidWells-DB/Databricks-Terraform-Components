# -----------------------------------------------------------------------------
# AWS Unity Catalog Metastore Foundation
# -----------------------------------------------------------------------------
# 1. Unity Catalog metastore (always, account plane)
# 2. AWS storage credential + data access (only when storage_root_url is set)
# 3. Metastore-to-workspace assignment (only when workspace_ids is non-empty)
#
# With no storage_root_url and no workspace_ids this is a storageless metastore
# at the account plane only (recommended; manage storage at the catalog level
# via the domain-catalog component).
# -----------------------------------------------------------------------------

locals {
  create_storage = var.storage_root_url != ""
}

module "storage_credential" {
  count  = local.create_storage ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-uc-storage-credential?ref=aws-uc-storage-credential/v0.1.0"

  providers = {
    databricks.workspace = databricks.workspace
  }

  credential_name      = var.credential_name
  role_name            = var.role_name
  bucket_name          = var.bucket_name
  aws_account_id       = var.aws_account_id
  aws_partition        = var.aws_partition
  databricks_gov_shard = var.databricks_gov_shard
}

module "metastore" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-metastore?ref=dbx-uc-metastore/v0.1.0"

  providers = {
    databricks.account = databricks.account
  }

  metastore_name   = var.metastore_name
  region           = var.region
  storage_root_url = local.create_storage ? var.storage_root_url : null
  data_access_name = local.create_storage ? var.data_access_name : null

  storage_credential = local.create_storage ? {
    aws_iam_role = {
      role_arn = try(module.storage_credential[0].iam_role_arn, "")
    }
    azure_managed_identity         = null
    databricks_gcp_service_account = null
  } : null
}

module "metastore_assignment" {
  count  = length(var.workspace_ids) > 0 ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-metastore-assignment?ref=dbx-uc-metastore-assignment/v0.1.0"

  providers = {
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
  }

  metastore_id  = module.metastore.metastore_id
  workspace_ids = var.workspace_ids
}
