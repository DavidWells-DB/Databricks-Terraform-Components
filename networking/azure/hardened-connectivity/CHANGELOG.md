# Changelog

All notable changes to the `networking/azure/hardened-connectivity` component are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and adheres to [Semantic Versioning](https://semver.org/). See [RELEASING.md](/RELEASING.md).

## [Unreleased]

## [0.2.0] - 2026-11-19

### Changed
- Upgrade the VNet Module pin to `azure-account-network-vnet/v0.2.0`.
- Constrain the AzureRM provider to versions before 5.0 for compatibility with the pinned private-endpoints Module.

## [0.1.0] - 2026-07-07

### Added
- Initial tagged release of the `hardened-connectivity` component. Composes v0.1.0 upstream modules; see `README.md` for inputs, outputs, and usage.
