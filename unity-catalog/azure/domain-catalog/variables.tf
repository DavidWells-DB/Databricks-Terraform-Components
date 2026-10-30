# -----------------------------------------------------------------------------
# Azure Unity Catalog Domain Catalog — inputs
# -----------------------------------------------------------------------------

variable "metastore_id" {
  description = "ID of the Unity Catalog metastore (from the metastore-foundation component)."
  type        = string
}

variable "catalog_name" {
  description = "Name of the catalog to create."
  type        = string
}

variable "catalog_comment" {
  description = "Comment/description for the catalog."
  type        = string
  default     = ""
}

variable "catalog_storage_root" {
  description = "ADOPT an existing managed storage root (abfss://container@account/...) for the catalog. When set, no storage is created and the storage-credential inputs must point at that account. Empty = create_catalog_storage decides."
  type        = string
  default     = ""
}

variable "create_catalog_storage" {
  description = "CREATE a dedicated ADLS Gen2 storage account + container for the catalog's managed storage — the default (best practice: catalog data on its own container, not the workspace root the platform's workspace catalog shares). Ignored when catalog_storage_root is set (adopt); set false to use metastore-default managed storage."
  type        = bool
  default     = true
}

variable "catalog_storage_path" {
  description = "Optional path suffix under the CREATED container. Default: container root."
  type        = string
  default     = null
}

variable "storage_account_name" {
  description = "Name for the created dedicated storage account. Empty = derived from the catalog name (underscores stripped + ucst, truncated to 24)."
  type        = string
  default     = ""
}

variable "container_name" {
  description = "Name for the created dedicated container. Empty = catalog."
  type        = string
  default     = ""
}

variable "storage_tags" {
  description = "Tags applied to the created storage account."
  type        = map(string)
  default     = {}
}

variable "catalog_isolation_mode" {
  description = "Isolation mode for the catalog (OPEN or ISOLATED)."
  type        = string
  default     = "OPEN"
}

variable "catalog_properties" {
  description = "Properties map for the catalog."
  type        = map(string)
  default     = {}
}

variable "catalog_grants" {
  description = "Grants for the catalog. Map of principal => list of privileges."
  type        = map(list(string))
  default     = {}
}

variable "schemas" {
  description = <<-EOT
    Map of schema names to their configuration.
    Each schema supports: comment, storage_root, properties, grants.
    Example:
    {
      bronze = {
        comment = "Raw ingested data"
        grants  = [{ principal = "data-engineers", privileges = ["ALL_PRIVILEGES"] }]
      }
    }
  EOT
  type = map(object({
    comment      = optional(string, null)
    storage_root = optional(string, null)
    properties   = optional(map(string), {})
    grants = optional(list(object({
      principal  = string
      privileges = list(string)
    })), [])
  }))
  default = {}
}

variable "external_locations" {
  description = <<-EOT
    Map of external location names to their configuration.
    Each location supports: url, comment, read_only, skip_validation, grants.
    Setting any external location requires the storage-credential inputs below.
  EOT
  type = map(object({
    url             = string
    comment         = optional(string, "")
    read_only       = optional(bool, false)
    skip_validation = optional(bool, false)
    grants          = optional(map(list(string)), {})
  }))
  default = {}
}

# -----------------------------------------------------------------------------
# Storage credential (required only when the catalog uses external storage:
# external_locations is non-empty or catalog_storage_root is set)
# -----------------------------------------------------------------------------

variable "credential_name" {
  description = "Name for the storage credential. Empty = derived (<catalog_name>_uc_cred)."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Resource group name for the Databricks access connector."
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region for the access connector."
  type        = string
  default     = ""
}

variable "storage_account_id" {
  description = "Resource ID of the EXISTING storage account for the credential — required only when adopting (catalog_storage_root set) or using external locations. Ignored when the dedicated storage is created."
  type        = string
  default     = ""
}

variable "access_connector_name" {
  description = "Name for the Databricks access connector. Empty = derived (<catalog_name-with-dashes>-uc-connector)."
  type        = string
  default     = ""
}
