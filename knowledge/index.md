# Databricks Terraform Components — Knowledge Bundle

An [OKF](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) knowledge bundle describing the composable Terraform components for Databricks networking and Unity Catalog across AWS, Azure, and GCP. Human-oriented usage docs live in each component's `README.md` under the repo root; this bundle is the agent-consumable knowledge layer that summarizes and cross-links them.

# References

* [Three-Tier Architecture](architecture.md) - the Modules → Components → Blueprints model this repo sits in the middle of.
* [Sovereign & Regulated Cloud Support](sovereign-clouds.md) - Databricks government/FedRAMP offerings per cloud and how the components support them.

# Networking

* [networking/](networking/) - AWS, Azure, and GCP workspace networking components (VPC/VNet, PrivateLink/PSC, firewalls, exfiltration protection).

# Unity Catalog

* [unity-catalog/](unity-catalog/) - metastore foundation and domain catalog components, structured per cloud.
