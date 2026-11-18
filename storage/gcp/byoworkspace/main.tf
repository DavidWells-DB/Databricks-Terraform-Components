data "google_storage_bucket" "this" {
  name = var.existing_bucket_name
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = data.google_storage_bucket.this.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.databricks_service_account_email}"
}

resource "google_storage_bucket_iam_member" "legacy_bucket_reader" {
  bucket = data.google_storage_bucket.this.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${var.databricks_service_account_email}"
}

resource "databricks_mws_storage_configurations" "this" {
  provider = databricks.account

  account_id                 = var.databricks_account_id
  storage_configuration_name = var.storage_configuration_name
  bucket_name                = data.google_storage_bucket.this.name

  depends_on = [
    google_storage_bucket_iam_member.object_admin,
    google_storage_bucket_iam_member.legacy_bucket_reader,
  ]
}
