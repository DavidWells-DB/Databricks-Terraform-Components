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

variable "metastore_name" {
  description = "Name of the Unity Catalog metastore to create."
  type        = string
}

variable "region" {
  description = "Cloud region for the metastore (e.g., us-east-1, eastus, us-central1)."
  type        = string
}

variable "storage_root_url" {
  description = "Optional root storage URL for the metastore (e.g., s3://bucket/path, abfss://container@account.dfs.core.windows.net, gs://bucket/path). Leave empty for a storageless metastore (recommended; manage storage at the catalog level via the domain-catalog component). When set, the matching cloud storage-credential inputs below are required."
  type        = string
  default     = ""
}

variable "data_access_name" {
  description = "Name for the data access configuration in the metastore. Required only when storage_root_url is set."
  type        = string
  default     = ""
}

variable "workspace_ids" {
  description = "Map of workspace label to workspace ID for metastore assignment."
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# AWS-specific Variables
# -----------------------------------------------------------------------------

variable "aws_credential_name" {
  description = "(AWS) Name for the storage credential."
  type        = string
  default     = ""
}

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

variable "azure_credential_name" {
  description = "(Azure) Name for the storage credential."
  type        = string
  default     = ""
}

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

variable "gcp_credential_name" {
  description = "(GCP) Name for the storage credential."
  type        = string
  default     = ""
}

variable "gcp_bucket_name" {
  description = "(GCP) GCS bucket name for the storage credential."
  type        = string
  default     = ""
}
