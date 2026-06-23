# -----------------------------------------------------------------------------
# Domain Catalog Component
# -----------------------------------------------------------------------------
# This component creates a domain/environment catalog within an existing
# Unity Catalog metastore. It is intended to be run MANY times - once per
# team, environment, or domain.
#
# It creates:
# 1. A catalog (always) and its schemas
# 2. Cloud-specific storage credential + external locations — only when the
#    catalog uses external storage (external_locations non-empty or
#    catalog_storage_root set). A catalog on metastore-default managed storage
#    needs no credential.
# -----------------------------------------------------------------------------

locals {
  # A storage credential is only needed when the catalog references external
  # storage — either via external locations or a dedicated catalog storage root.
  create_credential = length(var.external_locations) > 0 || var.catalog_storage_root != ""
}

# -----------------------------------------------------------------------------
# Cloud-Specific Storage Credentials (only one will be active, and only when
# the catalog uses external storage)
# -----------------------------------------------------------------------------

module "aws_storage_credential" {
  count  = (local.create_credential && var.cloud == "aws") ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-uc-storage-credential?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
  }

  credential_name      = var.credential_name
  role_name            = var.aws_role_name
  bucket_name          = var.aws_bucket_name
  aws_account_id       = var.aws_account_id
  aws_partition        = var.aws_partition
  databricks_gov_shard = var.databricks_gov_shard
}

module "azure_storage_credential" {
  count  = (local.create_credential && var.cloud == "azure") ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-uc-storage-credential?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
  }

  resource_group_name   = var.azure_resource_group_name
  location              = var.azure_location
  storage_account_id    = var.azure_storage_account_id
  credential_name       = var.credential_name
  access_connector_name = var.azure_access_connector_name
}

module "gcp_storage_credential" {
  count  = (local.create_credential && var.cloud == "gcp") ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-uc-storage-credential?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
  }

  credential_name = var.credential_name
  bucket_name     = var.gcp_bucket_name
}

# -----------------------------------------------------------------------------
# Locals - Resolve the active storage credential ID
# -----------------------------------------------------------------------------

locals {
  storage_credential_id = local.create_credential ? coalesce(
    var.cloud == "aws" ? try(module.aws_storage_credential[0].storage_credential_id, "") : "",
    var.cloud == "azure" ? try(module.azure_storage_credential[0].storage_credential_id, "") : "",
    var.cloud == "gcp" ? try(module.gcp_storage_credential[0].storage_credential_id, "") : "",
  ) : null

  # Build external locations map with storage_credential_id injected
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

# -----------------------------------------------------------------------------
# External Locations
# -----------------------------------------------------------------------------

module "external_locations" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-external-location?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
  }

  locations = local.external_locations_with_credential
}

# -----------------------------------------------------------------------------
# Catalog
# -----------------------------------------------------------------------------

module "catalog" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-catalog?ref=main"

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

# -----------------------------------------------------------------------------
# Schemas
# -----------------------------------------------------------------------------

module "schemas" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-schema?ref=main"

  providers = {
    databricks.workspace = databricks.workspace
  }

  catalog_name = var.catalog_name
  schemas      = var.schemas

  depends_on = [module.catalog]
}
