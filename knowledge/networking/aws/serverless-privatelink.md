---
type: Terraform Component
title: AWS Serverless PrivateLink
description: NCC + NLB + Endpoint Service so serverless compute reaches customer-managed services via PrivateLink.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/aws/serverless-privatelink
tags: [aws, networking, privatelink, serverless, ncc]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

Enables Databricks serverless compute (SQL Warehouses, Model Serving, Notebooks) to reach customer-managed services over AWS PrivateLink. Creates a Network Connectivity Configuration (NCC) and provisions an NLB + VPC Endpoint Service that Databricks serverless infrastructure connects to. Supports [AWS GovCloud](/sovereign-clouds.md) via `aws_partition` / `databricks_gov_shard`.

# Modules Composed

- `aws-account-network-connectivity-config`
- `aws-account-network-serverless-privatelink`

# Key Inputs

`databricks_account_id`, `region`, `resource_prefix`, `vpc_id`, `subnet_ids`, `target_ip`, `target_port` (required); `aws_partition`, `databricks_gov_shard` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/aws/serverless-privatelink/README.md) for full inputs, outputs, and usage.
