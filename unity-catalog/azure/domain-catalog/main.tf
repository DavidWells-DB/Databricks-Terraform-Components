# -----------------------------------------------------------------------------
# Azure Unity Catalog Domain Catalog
# -----------------------------------------------------------------------------
# 1. A catalog (always) and its schemas
# 2. Dedicated catalog managed storage — CREATED by default (the best practice:
#    catalog data on its own ADLS Gen2 container, never the workspace root the
#    platform's workspace catalog shares). catalog_storage_root set = ADOPT an
#    existing container+path instead; create_catalog_storage = false = metastore
#    default.
# 3. Azure storage credential + external locations — whenever the catalog uses
#    non-metastore storage (created storage, external_locations, or an adopted root).
# -----------------------------------------------------------------------------

locals {
  # Storage-mode precedence: adopt (catalog_storage_root) > create > metastore default.
  create_storage = var.create_catalog_storage && var.catalog_storage_root == ""

  create_credential = local.create_storage || length(var.external_locations) > 0 || var.catalog_storage_root != ""

  # The storage root the catalog actually uses (with the optional path suffix when created).
  created_storage_root   = local.create_storage ? "${try(module.uc_storage[0].storage_root, "")}${var.catalog_storage_path != null ? "/${var.catalog_storage_path}" : ""}" : ""
  effective_storage_root = var.catalog_storage_root != "" ? var.catalog_storage_root : local.created_storage_root

  # The credential's storage account: created (or adopted var) — never both.
  credential_storage_account_id = local.create_storage ? try(module.uc_storage[0].storage_account_id, "") : var.storage_account_id

  # Derived names when the caller leaves the optional inputs empty. Azure storage
  # account names are lowercase alphanumeric only (no underscores/dashes) and
  # globally unique — catalog underscores are stripped, and callers needing a
  # collision-proof name set storage_account_name explicitly.
  storage_account_name = var.storage_account_name != "" ? var.storage_account_name : substr("${replace(var.catalog_name, "_", "")}ucst", 0, 24)
  container_name       = var.container_name != "" ? var.container_name : "catalog"
  connector_name       = var.access_connector_name != "" ? var.access_connector_name : "${replace(var.catalog_name, "_", "-")}-uc-connector"
  cred_name            = var.credential_name != "" ? var.credential_name : "${var.catalog_name}_uc_cred"

  storage_credential_name = local.create_credential ? try(module.storage_credential[0].storage_credential_name, null) : null

  external_locations_with_credential = {
    for name, config in var.external_locations : name => {
      url                     = config.url
      storage_credential_name = local.storage_credential_name
      comment                 = config.comment
      read_only               = config.read_only
      skip_validation         = config.skip_validation
      grants                  = config.grants
    }
  }
}

# Dedicated ADLS Gen2 account + container for the catalog's managed storage —
# CREATE side of create-vs-adopt (Rule 8.4).
module "uc_storage" {
  count  = local.create_storage ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-uc-storage-bucket?ref=azure-uc-storage-bucket/v0.1.0"

  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name = local.storage_account_name
  container_name       = local.container_name

  tags = var.storage_tags
}

module "storage_credential" {
  count  = local.create_credential ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//azure-uc-storage-credential?ref=azure-uc-storage-credential/v0.1.0"

  providers = {
    databricks.workspace = databricks.workspace
  }

  resource_group_name   = var.resource_group_name
  location              = var.location
  storage_account_id    = local.credential_storage_account_id
  credential_name       = local.cred_name
  access_connector_name = local.connector_name
}

module "external_locations" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//dbx-uc-external-location?ref=dbx-uc-external-location/v0.2.0"

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
