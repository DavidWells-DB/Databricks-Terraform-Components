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

variable "network_name" {
  description = "Name for the VPC network"
  type        = string
  default     = ""
}

variable "subnetwork_name" {
  description = "Optional subnetwork creation name. Null derives '<resource_prefix>-subnet'."
  type        = string
  default     = null
}

variable "pod_secondary_range_name" {
  description = "Optional pod secondary-range creation name."
  type        = string
  default     = null
}

variable "service_secondary_range_name" {
  description = "Optional service secondary-range creation name."
  type        = string
  default     = null
}

variable "firewall_rule_name" {
  description = "Optional Databricks ingress firewall-rule creation name."
  type        = string
  default     = null
}

variable "router_name" {
  description = "Optional Cloud Router creation name."
  type        = string
  default     = null
}

variable "nat_name" {
  description = "Optional Cloud NAT creation name."
  type        = string
  default     = null
}

variable "min_ports_per_vm" {
  description = "Minimum ports per VM for Cloud NAT."
  type        = number
  default     = 64
}

variable "log_config_enable" {
  description = "Enable Cloud NAT logging."
  type        = bool
  default     = false
}

variable "log_config_filter" {
  description = "Cloud NAT log filter: ALL, ERRORS_ONLY, or TRANSLATIONS_ONLY."
  type        = string
  default     = "ERRORS_ONLY"
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
