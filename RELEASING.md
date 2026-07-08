# Releasing Components

How to cut immutable, pinnable releases for the components in this repo. Released tags are **immutable** — downstream Blueprints depend on them.

## The three-tier contract

This repo is the **component tier**. It pins specific **module** tags (`?ref=<module>/vX.Y.Z`); the tier above — **Blueprints** — pins **component** tags. The chain only works if component tags never move.

`main` is an integration branch, not a consumption target. Every consumable change is published as an immutable per-component semver tag; consumers pin it.

## Tag format

Each component is versioned independently. A component's tag is its **repo-relative path** followed by the version:

```
networking/aws/basic/v0.1.0
unity-catalog/aws/metastore-foundation/v0.1.0
```

Each component has its own `CHANGELOG.md`.

## Stability policy: v0.x vs v1.0.0

| Range | Meaning | When |
|---|---|---|
| `v0.x.y` | Interface not yet stable; minor bumps may break | Default for new components. |
| `v1.0.0+` | Interface committed; breaking changes require a MAJOR | Only once the variable/output surface is stable and consumed in production. |

Components start at **v0.1.0** — they pin `v0.x` modules and their own interfaces are still settling.

## Pre-flight (required before any tag)

```bash
COMPONENT=networking/aws/basic   # repo-relative path

terraform fmt -check -recursive "$COMPONENT"
# Components declare aliased providers (databricks.account/.workspace, aws/azurerm/google)
# via configuration_aliases, so `terraform validate` needs stub provider blocks
# supplied by the caller. Validate from a harness that provides them, or a
# temporary _test_provider.tf (gitignored).
```

## Cutting a release

1. Ensure `main` is clean and green.
2. In `<component>/CHANGELOG.md`, convert `[Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD` and add a fresh empty `[Unreleased]` above it.
3. Verify the tag is ready:
   ```bash
   scripts/check-release-tag.sh <component>/vX.Y.Z --remote
   ```
4. Tag and push:
   ```bash
   git tag -a <component>/vX.Y.Z -m "<component> vX.Y.Z"
   git push origin <component>/vX.Y.Z
   ```

## Tag immutability

Published tags are never force-moved. If a tag was wrong, cut a new version. The `release-check` workflow (and, ideally, a repo rule blocking force-pushes to `refs/tags/**`) enforce this.

## Registry note

Git-tag pinning is the interim mechanism. If/when components publish to the Terraform Registry, consumers switch to `version` constraints and this scheme is superseded.
