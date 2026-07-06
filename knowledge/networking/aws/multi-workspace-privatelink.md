---
type: Terraform Component
title: AWS Multi-Workspace PrivateLink
description: Shared VPC with backend PrivateLink (REST API + SCC relay) for multiple workspaces.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/aws/multi-workspace-privatelink
tags: [aws, networking, privatelink, shared-vpc]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

A shared VPC with backend PrivateLink connectivity (REST API + Secure Cluster Connectivity relay) that can be shared across multiple Databricks workspaces, plus NAT egress and standard VPC endpoints. Supports [AWS GovCloud](/sovereign-clouds.md) via `databricks_gov_shard`.

# Modules Composed

- `aws-account-network-vpc`
- `aws-account-network-privatelink-endpoints`
- `aws-account-network-egress-internet`
- `aws-account-network-vpc-endpoints`

# Key Inputs

`databricks_account_id`, `region`, `resource_prefix` (required); subnet/PrivateLink CIDRs, `security_group_ingress_cidr_blocks`, `databricks_gov_shard` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/aws/multi-workspace-privatelink/README.md) for full inputs, outputs, and usage.
