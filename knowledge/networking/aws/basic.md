---
type: Terraform Component
title: AWS Basic Networking
description: Standard Databricks-ready VPC with NAT egress and S3/STS/Kinesis endpoints.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/aws/basic
tags: [aws, networking, vpc, baseline]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

The simplest AWS workspace networking tier: a Databricks-ready VPC with private/public subnets, a NAT gateway for egress, and the essential S3/STS/Kinesis VPC endpoints. Supports [AWS GovCloud](/sovereign-clouds.md) via `databricks_gov_shard`.

# Modules Composed

- `aws-account-network-vpc`
- `aws-account-network-egress-internet`
- `aws-account-network-vpc-endpoints`

# Key Inputs

`databricks_account_id`, `region`, `resource_prefix` (required); `vpc_cidr`, subnet CIDRs, `databricks_gov_shard`, `tags` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/aws/basic/README.md) for full inputs, outputs, and usage.
