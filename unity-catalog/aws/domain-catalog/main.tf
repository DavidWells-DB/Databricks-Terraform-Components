# -----------------------------------------------------------------------------
# AWS Unity Catalog Domain Catalog
# -----------------------------------------------------------------------------
# 1. A catalog (always) and its schemas
# 2. AWS storage credential + external locations — only when the catalog uses
#    external storage (external_locations non-empty or catalog_storage_root set).
#    A catalog on metastore-default managed storage needs no credential.
# -----------------------------------------------------------------------------

locals {
  create_credential = length(var.external_locations) > 0 || var.catalog_storage_root != ""

  storage_credential_id = local.create_credential ? try(module.storage_credential[0].storage_credential_id, null) : null

  external_locations_with_credential = {
    for name, config in var.external_locations : name => {
      url                   = config.url
      storage_credential_id = local.storage_credential_id
      comment               = config.comment
      read_only             = config.read_only
      skip_validation       = config.skip_validation
      grants                = config.grants
    }
  }
}

module "storage_credential" {
  count  = local.create_credential ? 1 : 0
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

module "external_locations" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-external-location?ref=dbx-uc-external-location/v0.1.0"

  providers = {
    databricks.workspace = databricks.workspace
  }

  locations = local.external_locations_with_credential
}

module "catalog" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-catalog?ref=dbx-uc-catalog/v0.1.0"

  providers = {
    databricks.workspace = databricks.workspace
  }

  metastore_id = var.metastore_id
  catalogs = {
    (var.catalog_name) = {
      comment        = var.catalog_comment
      storage_root   = var.catalog_storage_root
      isolation_mode = var.catalog_isolation_mode
      properties     = var.catalog_properties
      grants         = var.catalog_grants
    }
  }
}

module "schemas" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-schema?ref=dbx-uc-schema/v0.1.0"

  providers = {
    databricks.workspace = databricks.workspace
  }

  catalog_name = var.catalog_name
  schemas      = var.schemas

  depends_on = [module.catalog]
}
