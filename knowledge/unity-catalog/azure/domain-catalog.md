---
type: Terraform Component
title: Azure Domain Catalog
description: A catalog + schemas within an existing metastore on Azure; storage credential only when using external storage.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/unity-catalog/azure/domain-catalog
tags: [azure, unity-catalog, catalog, schema]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

Creates a domain/environment catalog (and its schemas) within an existing Unity Catalog metastore on Azure — run **once per team/env/domain**. A catalog on metastore-default managed storage needs no credential; a storage credential (access connector) + external locations are created only when the catalog uses external storage.

# Modules Composed

- `dbx-uc-catalog`, `dbx-uc-schema` (always)
- `dbx-uc-external-location` (no-op when `external_locations` empty)
- `azure-uc-storage-credential` (when external storage is used)

# Related

- Requires a metastore from [Azure Metastore Foundation](metastore-foundation.md).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/unity-catalog/azure/domain-catalog/README.md) for full inputs, outputs, and usage.
