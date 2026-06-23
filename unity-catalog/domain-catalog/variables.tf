# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------

variable "cloud" {
  description = "Cloud provider for this deployment. Must be one of: aws, azure, gcp."
  type        = string

  validation {
    condition     = contains(["aws", "azure", "gcp"], var.cloud)
    error_message = "The cloud variable must be one of: aws, azure, gcp."
  }
}

variable "metastore_id" {
  description = "ID of the Unity Catalog metastore (from metastore-foundation component)."
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
  description = "Optional managed storage root for the catalog. If empty, uses metastore default."
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
        comment      = "Raw ingested data"
        storage_root = ""
        properties   = {}
        grants       = { "data-engineers" = ["ALL_PRIVILEGES"] }
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
    Example:
    {
      raw_data = {
        url             = "s3://my-bucket/raw/"
        comment         = "Raw data location"
        read_only       = false
        skip_validation = false
        grants          = { "data-engineers" = ["ALL_PRIVILEGES"] }
      }
    }
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
# Storage Credential Configuration
# -----------------------------------------------------------------------------

variable "credential_name" {
  description = "Name for the storage credential used by this domain catalog. Required only when the catalog uses external storage (external_locations is non-empty or catalog_storage_root is set); leave empty for a catalog on metastore-default managed storage."
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# AWS-specific Variables
# -----------------------------------------------------------------------------

variable "aws_role_name" {
  description = "(AWS) IAM role name for the storage credential."
  type        = string
  default     = ""
}

variable "aws_bucket_name" {
  description = "(AWS) S3 bucket name for the storage credential."
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "(AWS) AWS account ID."
  type        = string
  default     = ""
}

variable "aws_partition" {
  description = "(AWS) AWS partition (aws or aws-us-gov)."
  type        = string
  default     = "aws"
}

variable "databricks_gov_shard" {
  description = "(AWS) Whether to use the Databricks government shard."
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Azure-specific Variables
# -----------------------------------------------------------------------------

variable "azure_resource_group_name" {
  description = "(Azure) Resource group name for the access connector."
  type        = string
  default     = ""
}

variable "azure_location" {
  description = "(Azure) Azure region for the access connector."
  type        = string
  default     = ""
}

variable "azure_storage_account_id" {
  description = "(Azure) Storage account resource ID."
  type        = string
  default     = ""
}

variable "azure_access_connector_name" {
  description = "(Azure) Name for the access connector."
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# GCP-specific Variables
# -----------------------------------------------------------------------------

variable "gcp_bucket_name" {
  description = "(GCP) GCS bucket name for the storage credential."
  type        = string
  default     = ""
}
