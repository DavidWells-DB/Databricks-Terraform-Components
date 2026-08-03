# Changelog

All notable changes to the `networking/aws/basic` component are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and adheres to [Semantic Versioning](https://semver.org/). See [RELEASING.md](/RELEASING.md).

## [Unreleased]

## [0.2.0] - 2026-08-02

### Fixed
- **Component now plans on required-only inputs (open-item E3).** `availability_zones`, `private_subnet_cidrs`, and `public_subnet_cidrs` defaulted to `[]` while the underlying VPC module requires >= 2 AZs' worth, so callers had to supply all three (blueprints worked around it locally). The component now self-derives safe defaults: AZs from the first `az_count` available zones in the region, one `/20` private subnet per AZ and one `/24` public subnet per AZ from `vpc_cidr`. Explicit inputs still override the derivation.

### Added
- `az_count` input (default `2`, minimum `2`) controlling how many AZs the auto-derivation spans when `availability_zones` is not supplied.

## [0.1.0] - 2026-07-07

### Added
- Initial tagged release of the `basic` component. Composes v0.1.0 upstream modules; see `README.md` for inputs, outputs, and usage.
