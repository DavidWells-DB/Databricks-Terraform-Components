# -----------------------------------------------------------------------------
# GCP Unity Catalog Domain Catalog
# -----------------------------------------------------------------------------
# 1. A catalog (always) and its schemas
# 2. Dedicated catalog managed storage — CREATED by default (the best practice:
#    catalog data on its own GCS bucket, never the workspace root the platform's
#    workspace catalog shares). catalog_storage_root set = ADOPT an existing
#    bucket+path instead; create_catalog_storage = false = metastore default.
# 3. GCP storage credential + external locations — whenever the catalog uses
#    non-metastore storage (created storage, external_locations, or an adopted root).
# -----------------------------------------------------------------------------

locals {
  # Storage-mode precedence: adopt (catalog_storage_root) > create > metastore default.
  create_storage = var.create_catalog_storage && var.catalog_storage_root == ""

  create_credential = local.create_storage || length(var.external_locations) > 0 || var.catalog_storage_root != ""

  # The storage root the catalog actually uses (with the optional path suffix when created).
  created_storage_root   = local.create_storage ? "${try(module.uc_storage[0].storage_root, "")}${var.catalog_storage_path != null ? "/${var.catalog_storage_path}" : ""}" : ""
  effective_storage_root = var.catalog_storage_root != "" ? var.catalog_storage_root : local.created_storage_root

  # The credential's bucket: created (or adopted var) — never both.
  credential_bucket_name = local.create_storage ? try(module.uc_storage[0].bucket_name, "") : var.bucket_name

  # Derived names when the caller leaves the optional inputs empty.
  bucket_name = var.bucket_name != "" ? var.bucket_name : "${var.catalog_name}-uc"
  cred_name   = var.credential_name != "" ? var.credential_name : "${var.catalog_name}_uc_cred"

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

# Dedicated GCS bucket for the catalog's managed storage — CREATE side of
# create-vs-adopt (Rule 8.4).
module "uc_storage" {
  count  = local.create_storage ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-uc-storage-bucket?ref=gcp-uc-storage-bucket/v0.1.0"

  bucket_name = local.bucket_name
  location    = var.bucket_location
  labels      = var.bucket_labels
}

module "storage_credential" {
  count  = local.create_credential ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-uc-storage-credential?ref=gcp-uc-storage-credential/v0.1.0"

  providers = {
    databricks.workspace = databricks.workspace
  }

  credential_name = local.cred_name
  bucket_name     = local.credential_bucket_name
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
      storage_root   = local.effective_storage_root
      isolation_mode = var.catalog_isolation_mode
      properties     = var.catalog_properties
      # var.catalog_grants is principal => privileges; the dbx-uc-catalog module
      # takes the list-of-object form — convert here (the type mismatch otherwise
      # fails even with the empty default).
      grants = [for principal, privileges in var.catalog_grants : {
        principal  = principal
        privileges = privileges
      }]
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
