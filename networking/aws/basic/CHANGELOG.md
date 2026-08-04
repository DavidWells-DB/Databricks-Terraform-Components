# Changelog

All notable changes to the `networking/aws/basic` component are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and adheres to [Semantic Versioning](https://semver.org/). See [RELEASING.md](/RELEASING.md).

## [Unreleased]

## [0.3.1] - 2026-08-03

### Fixed
- **Dependency cycle in back-end PrivateLink wiring.** v0.3.0 derived the PrivateLink subnets from `vpc_endpoint_ids != null`, but the endpoints are placed *in* those subnets — so subnets→endpoints→`vpc_endpoint_ids`→subnets cycled at plan time. Added a plan-time boolean **`enable_privatelink_subnets`** that drives subnet creation independently of the endpoint IDs (which now feed only the `mws_networks` registration). Set `enable_privatelink_subnets = true` alongside `vpc_endpoint_ids` when composing back-end PrivateLink. (The v0.3.0 cycle-freedom test passed only because it hand-fed `privatelink_subnet_cidrs`; the derived path was untested — fixed and now validated in composition.)

## [0.3.0] - 2026-08-03

### Added
- **Back-end PrivateLink pass-through.** New inputs `vpc_endpoint_ids` (`{rest_api_id, relay_id}`) and `privatelink_subnet_cidrs`, forwarded to the underlying `aws-account-network-vpc` module so PrivateLink VPC endpoints are registered into `databricks_mws_networks` (control-plane + SCC-relay over PrivateLink). New output `privatelink_subnet_ids` for placing the endpoints. When `vpc_endpoint_ids` is set and `privatelink_subnet_cidrs` is empty, one `/24` PrivateLink subnet per AZ is derived from `vpc_cidr` (offset 250, no collision with public/private). This lets a classic workspace config enable back-end PrivateLink as an in-place flag. Verified acyclic: endpoints depend on this Component's VPC; `mws_networks` depends on the endpoints — no dependency cycle.

## [0.2.0] - 2026-08-02

### Fixed
- **Component now plans on required-only inputs (open-item E3).** `availability_zones`, `private_subnet_cidrs`, and `public_subnet_cidrs` defaulted to `[]` while the underlying VPC module requires >= 2 AZs' worth, so callers had to supply all three (blueprints worked around it locally). The component now self-derives safe defaults: AZs from the first `az_count` available zones in the region, one `/20` private subnet per AZ and one `/24` public subnet per AZ from `vpc_cidr`. Explicit inputs still override the derivation.

### Added
- `az_count` input (default `2`, minimum `2`) controlling how many AZs the auto-derivation spans when `availability_zones` is not supplied.

## [0.1.0] - 2026-07-07

### Added
- Initial tagged release of the `basic` component. Composes v0.1.0 upstream modules; see `README.md` for inputs, outputs, and usage.
