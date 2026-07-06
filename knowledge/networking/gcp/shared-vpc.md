---
type: Terraform Component
title: GCP Shared VPC
description: Shared VPC host project network with Cloud NAT, associating one or more service projects.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/gcp/shared-vpc
tags: [gcp, networking, shared-vpc, host-project]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

Provisions a Shared VPC host-project network with Cloud NAT and attaches one or more service projects. The VPC and subnets live in the host project; Databricks workspaces are deployed in the service projects that consume the shared network.

# Modules Composed

- `gcp-account-network-vpc`
- `gcp-account-network-cloud-nat`
- `gcp-account-network-shared-vpc`

# Key Inputs

`databricks_account_id`, `host_project_id`, `service_project_ids`, `region`, `resource_prefix` (required); `network_cidr`, secondary ranges (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/gcp/shared-vpc/README.md) for full inputs, outputs, and usage.
