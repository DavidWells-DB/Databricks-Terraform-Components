mock_provider "google" {
  mock_data "google_storage_bucket" {
    defaults = {
      name      = "existing-root-bucket"
      url       = "gs://existing-root-bucket"
      self_link = "https://www.googleapis.com/storage/v1/b/existing-root-bucket"
    }
  }
}

mock_provider "databricks" {
  alias = "account"
}

variables {
  databricks_account_id            = "44444444-4444-4444-4444-444444444444"
  existing_bucket_name             = "existing-root-bucket"
  databricks_service_account_email = "provisioner@my-gcp-project.iam.gserviceaccount.com"
  storage_configuration_name       = "customer-storage"
}

run "references_bucket_and_creates_iam_and_registration" {
  command = plan

  assert {
    condition     = google_storage_bucket_iam_member.object_admin.member == "serviceAccount:provisioner@my-gcp-project.iam.gserviceaccount.com" && google_storage_bucket_iam_member.legacy_bucket_reader.bucket == "existing-root-bucket"
    error_message = "The existing provisioning identity must receive both required bucket roles"
  }
  assert {
    condition     = databricks_mws_storage_configurations.this.bucket_name == "existing-root-bucket" && databricks_mws_storage_configurations.this.storage_configuration_name == "customer-storage"
    error_message = "The storage registration must use the existing bucket and explicit name"
  }
}
