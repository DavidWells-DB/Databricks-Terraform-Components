# Changelog

All notable changes to the `unity-catalog/aws/domain-catalog` component are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and adheres to [Semantic Versioning](https://semver.org/). See [RELEASING.md](/RELEASING.md).

## [Unreleased]

## [0.2.0] - 2026-10-30

### Added — dedicated catalog storage, created by default (best practice)
- `create_catalog_storage` (default **true**): composes the new `aws-uc-storage-bucket` module — a dedicated S3 bucket for the catalog's managed storage (catalog data on its own bucket, never the workspace root the platform's workspace catalog shares; OKF unity-catalog). Creates the storage credential against the created bucket automatically; `catalog_storage_path` adds an optional path suffix.
- Adopt path unchanged and now explicit: `catalog_storage_root` set = use an existing bucket+path and point the credential at it (create-vs-adopt, Rule 8.4). Set `create_catalog_storage = false` for metastore-default managed storage (the pre-0.2.0 behavior).
- Derived names when optional inputs are empty: bucket `<catalog_name>-uc`, IAM role `<catalog_name>-uc-role`, credential `<catalog_name>_uc_cred` — so the default mode needs NO extra mandatory inputs.
- New outputs: `catalog_storage_root` (what the catalog actually uses) and `created_bucket_name`.

### Fixed — pre-existing, surfaced by validation
- `catalog_grants` type mismatch: the component's principal=>privileges map is now converted to the list-of-object form `dbx-uc-catalog` expects — the old pass-through failed plan even with the empty default.


## [0.1.0] - 2026-07-07

### Added
- Initial tagged release of the `domain-catalog` component. Composes v0.1.0 upstream modules; see `README.md` for inputs, outputs, and usage.
