# Changelog

All notable changes to the `networking/gcp/byovpc` component are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and adheres to [Semantic Versioning](https://semver.org/). See [RELEASING.md](/RELEASING.md).

## [Unreleased]

## [0.1.1] - 2026-10-09

### Changed
- Pin `gcp-account-network-vpc` to v0.1.1: the VPC module now ignores Databricks' post-creation `target_tags` on the required ingress firewall (added at workspace creation in place), so plans on workspace-bearing networks stay clean.

## [0.1.0] - 2026-07-07

### Added
- Initial tagged release of the `byovpc` component. Composes v0.1.0 upstream modules; see `README.md` for inputs, outputs, and usage.
