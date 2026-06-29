# -----------------------------------------------------------------------------
# AWS Unity Catalog Domain Catalog — inputs
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
  description = "Optional managed storage root (s3://...) for the catalog. If empty, uses metastore default. Setting this requires the storage-credential inputs below."
  type        = string
  default     = ""
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
  description = "Name for the storage credential. Required only when the catalog uses external storage."
  type        = string
  default     = ""
}

variable "role_name" {
  description = "IAM role name for the storage credential (the module creates this role)."
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "S3 bucket name for the storage credential."
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "AWS account ID."
  type        = string
  default     = ""
}

variable "aws_partition" {
  description = "AWS partition for ARN construction: \"aws\" (commercial) or \"aws-us-gov\" (GovCloud). See docs/GOVCLOUD.md."
  type        = string
  default     = "aws"
}

variable "databricks_gov_shard" {
  description = "Databricks GovCloud shard: null (commercial), \"civilian\" (FedRAMP High), or \"dod\" (IL5). See docs/GOVCLOUD.md."
  type        = string
  default     = null

  validation {
    condition     = var.databricks_gov_shard == null || contains(["civilian", "dod"], var.databricks_gov_shard)
    error_message = "databricks_gov_shard must be null, \"civilian\", or \"dod\"."
  }
}
