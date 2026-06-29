# -----------------------------------------------------------------------------
# Azure Unity Catalog Metastore Foundation — inputs
# -----------------------------------------------------------------------------

variable "metastore_name" {
  description = "Name of the Unity Catalog metastore to create."
  type        = string
}

variable "region" {
  description = "Azure region for the metastore (e.g., eastus)."
  type        = string
}

variable "storage_root_url" {
  description = "Optional ADLS root storage URL for the metastore (e.g., abfss://container@account.dfs.core.windows.net/). Leave empty for a storageless metastore (recommended; manage storage at the catalog level via domain-catalog). When set, the storage-credential inputs below are required."
  type        = string
  default     = ""
}

variable "data_access_name" {
  description = "Name for the metastore data access configuration. Required only when storage_root_url is set."
  type        = string
  default     = ""
}

variable "workspace_ids" {
  description = "Map of workspace label to workspace ID for metastore assignment. Empty = create the metastore without assigning it."
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# Storage credential (required only when storage_root_url is set)
# -----------------------------------------------------------------------------

variable "credential_name" {
  description = "Name for the storage credential."
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
  description = "Resource ID of the storage account backing the metastore."
  type        = string
  default     = ""
}

variable "access_connector_name" {
  description = "Name for the Databricks access connector."
  type        = string
  default     = ""
}
