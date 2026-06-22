variable "databricks_account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for networking resources"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
}

variable "spoke_network_cidr" {
  description = "Primary CIDR block for the spoke VPC (Databricks workspace subnet)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "pod_secondary_range_cidr" {
  description = "Secondary CIDR range for GKE pods"
  type        = string
  default     = "10.1.0.0/16"
}

variable "service_secondary_range_cidr" {
  description = "Secondary CIDR range for GKE services"
  type        = string
  default     = "10.2.0.0/20"
}

variable "hub_network_cidr" {
  description = "CIDR block for the hub VPC subnet"
  type        = string
  default     = "10.3.0.0/24"
}

variable "psc_subnet_cidr" {
  description = "CIDR block for the PSC endpoint subnet in the hub VPC"
  type        = string
  default     = "10.3.1.0/24"
}

variable "google_apis_cidr" {
  description = "CIDR for Google Private API access (restricted.googleapis.com)"
  type        = string
  default     = "199.36.153.4/30"
}

variable "public_access_enabled" {
  description = "Whether public access is enabled for the workspace"
  type        = bool
  default     = false
}
