# GCP existing workspace root storage

References an existing GCS bucket, grants the selected provisioning service
account the two bucket roles required by Databricks, and creates the storage
registration. Bucket encryption, retention, lifecycle, public-access settings,
and deletion remain caller-owned.
