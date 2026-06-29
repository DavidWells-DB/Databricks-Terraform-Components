# -----------------------------------------------------------------------------
# AWS Unity Catalog Metastore Foundation — inputs
# -----------------------------------------------------------------------------

variable "metastore_name" {
  description = "Name of the Unity Catalog metastore to create."
  type        = string
}

variable "region" {
  description = "AWS region for the metastore (e.g., us-east-1)."
  type        = string
}

variable "storage_root_url" {
  description = "Optional S3 root storage URL for the metastore (e.g., s3://bucket/path). Leave empty for a storageless metastore (recommended; manage storage at the catalog level via domain-catalog). When set, the storage-credential inputs below are required."
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

variable "role_name" {
  description = "IAM role name for the storage credential (the module creates this role)."
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "S3 bucket name backing the metastore storage credential."
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
