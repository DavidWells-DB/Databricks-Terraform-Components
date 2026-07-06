---
type: Terraform Component
title: GCP Metastore Foundation
description: Unity Catalog metastore foundation for a GCP region; storageless by default.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/unity-catalog/gcp/metastore-foundation
tags: [gcp, unity-catalog, metastore, account-plane]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

Creates the Unity Catalog metastore for a GCP region — run **once per region**. Defaults to a **storageless** metastore (recommended); optionally attaches a GCS storage root via a Databricks service account and assigns workspaces. A storageless, unassigned metastore is account-plane only.

# Modules Composed

- `dbx-uc-metastore` (always)
- `gcp-uc-storage-credential` (when `storage_root_url` is set)
- `dbx-uc-metastore-assignment` (when `workspace_ids` is non-empty)

# Related

- Consumed by [GCP Domain Catalog](domain-catalog.md).
- See [Three-Tier Architecture](/architecture.md).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/unity-catalog/gcp/metastore-foundation/README.md) for full inputs, outputs, and usage.
