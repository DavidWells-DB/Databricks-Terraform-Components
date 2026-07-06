# Azure Networking Components

Ordered roughly from least to most restrictive.

* [Azure Managed Security](managed-security.md) - VNet injection + Secure Cluster Connectivity (No Public IP).
* [Azure Hub-Spoke Firewall](hub-spoke-firewall.md) - Azure Firewall egress filtering, public front-end.
* [Azure NCC + Storage](ncc-storage.md) - Serverless NCC + classic VNet; each half independently toggleable.
* [Azure Hardened Connectivity](hardened-connectivity.md) - VNet injection with back-end Private Link.
* [Azure Isolated](isolated.md) - Full Private Link + Azure Firewall, hub-spoke; most restrictive.
