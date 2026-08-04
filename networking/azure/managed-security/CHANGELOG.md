# Changelog

All notable changes to the `networking/azure/managed-security` component are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and adheres to [Semantic Versioning](https://semver.org/). See [RELEASING.md](/RELEASING.md).

## [Unreleased]

## [0.2.0] - 2026-08-04

### Added
- **`host_subnet_nsg_association_id` + `container_subnet_nsg_association_id` outputs** (pass-through from `azure-account-network-vnet` v0.2.0, which this component now pins). `azure-account-workspace` requires these NSG-association IDs whenever `virtual_network_id` is set — they are the dependency that stops the workspace being created before the NSGs are associated with the subnets. Without them a VNet-injected Azure workspace cannot be composed from this component.

### Changed
- Repinned `azure-account-network-vnet` `v0.1.0` → `v0.2.0`.

## [0.1.0] - 2026-07-07

### Added
- Initial tagged release of the `managed-security` component. Composes v0.1.0 upstream modules; see `README.md` for inputs, outputs, and usage.
