variable "databricks_account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "host_project_id" {
  description = "GCP project ID for the Shared VPC host project"
  type        = string
}

variable "service_project_ids" {
  description = "List of GCP project IDs to attach as service projects"
  type        = list(string)
}

variable "region" {
  description = "GCP region for networking resources"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
}

variable "network_name" {
  description = "Name for the VPC network"
  type        = string
  default     = ""
}

variable "network_cidr" {
  description = "Primary CIDR block for the GKE node subnet"
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
