---
type: Terraform Component
title: AWS Firewall Networking
description: VPC with AWS Network Firewall for fine-grained egress filtering.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/aws/firewall
tags: [aws, networking, firewall, egress-control]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

A Databricks-ready VPC that routes workspace egress through AWS Network Firewall for fine-grained outbound control. Supports [AWS GovCloud](/sovereign-clouds.md) via `databricks_gov_shard`.

# Modules Composed

- `aws-account-network-vpc`
- `aws-account-network-firewall`
- `aws-account-network-egress-internet`
- `aws-account-network-vpc-endpoints`

# Key Inputs

`databricks_account_id`, `region`, `resource_prefix` (required); firewall subnet CIDRs, `firewall_stateful_rule_group_arns`, `databricks_gov_shard` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/aws/firewall/README.md) for full inputs, outputs, and usage.
