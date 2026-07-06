---
type: Terraform Component
title: GCP BYOVPC
description: Customer-managed VPC with Cloud NAT — the standard GCP workspace pattern.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/gcp/byovpc
tags: [gcp, networking, vpc, byovpc]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

The standard GCP pattern: a customer-managed VPC with a primary subnet, GKE pod/service secondary ranges, and Cloud NAT for outbound egress. The customer retains full control of the VPC.

# Modules Composed

- `gcp-account-network-vpc`
- `gcp-account-network-cloud-nat`

# Key Inputs

`databricks_account_id`, `project_id`, `region`, `resource_prefix` (required); `network_cidr`, `pod_secondary_range_cidr`, `service_secondary_range_cidr` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/gcp/byovpc/README.md) for full inputs, outputs, and usage.
