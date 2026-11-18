# Changelog

All notable changes to the `networking/aws/byovpc` component are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and adheres to [Semantic Versioning](https://semver.org/). See [RELEASING.md](/RELEASING.md).

## [Unreleased]

## [0.1.1] - 2026-11-18

### Added
- Optional exact name for the Databricks security group created in an existing VPC, with validation against the mutually exclusive existing-security-group input.

## [0.1.0] - 2026-11-10

### Added
- Initial component — the ADOPT twin of `networking/aws/basic` (create-vs-adopt, Rule 8.4): registers an EXISTING customer VPC with `databricks_mws_networks` using the same retain-old-config PrivateLink pattern as `aws-account-network-vpc` v0.3.0 (base + optional `-privatelink` registration; workspace repointed in place). Same output contract as `basic` (plus echo passthroughs for public subnets / private route tables / PL subnets so the egress-endpoints / vpc-endpoints / privatelink-endpoints modules compose unchanged).
- Optional Databricks-required security group creation in the BYO VPC (bring your own via `existing_security_group_ids` to skip).
- Map-not-list input shapes for caller-provided subnet IDs (the twice-proven pattern).
