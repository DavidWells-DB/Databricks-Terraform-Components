# Unity Catalog Components

Metastore and catalog foundations, organized structurally by cloud (there is no runtime `cloud` toggle). Two components per cloud: a regional metastore foundation and a per-domain catalog.

# Clouds

* [aws/](aws/) - AWS metastore-foundation + domain-catalog.
* [azure/](azure/) - Azure metastore-foundation + domain-catalog.
* [gcp/](gcp/) - GCP metastore-foundation + domain-catalog.

Metastores default to **storageless** (recommended); catalogs manage their own storage only when they use external locations or a dedicated catalog root.
