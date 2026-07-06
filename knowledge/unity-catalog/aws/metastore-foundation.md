---
type: Terraform Component
title: AWS Metastore Foundation
description: Unity Catalog metastore foundation for an AWS region; storageless by default.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/unity-catalog/aws/metastore-foundation
tags: [aws, unity-catalog, metastore, account-plane]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

Creates the Unity Catalog metastore for an AWS region — run **once per region**. Defaults to a **storageless** metastore (recommended); optionally attaches an S3 storage root + credential and assigns workspaces. A storageless, unassigned metastore is account-plane only (needs just `databricks.account`). Supports [AWS GovCloud](/sovereign-clouds.md) via `databricks_gov_shard`.

# Modules Composed

- `dbx-uc-metastore` (always)
- `aws-uc-storage-credential` (when `storage_root_url` is set)
- `dbx-uc-metastore-assignment` (when `workspace_ids` is non-empty)

# Related

- Consumed by [AWS Domain Catalog](domain-catalog.md).
- See [Three-Tier Architecture](/architecture.md).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/unity-catalog/aws/metastore-foundation/README.md) for full inputs, outputs, and usage.
