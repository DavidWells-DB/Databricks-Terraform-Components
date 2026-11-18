mock_provider "google" {
  mock_data "google_service_account" {
    defaults = {
      email     = "provisioner@my-gcp-project.iam.gserviceaccount.com"
      name      = "projects/my-gcp-project/serviceAccounts/provisioner@my-gcp-project.iam.gserviceaccount.com"
      unique_id = "123456789012345678901"
    }
  }
}

mock_provider "databricks" {
  alias = "account"
}

variables {
  project_id                     = "my-gcp-project"
  existing_service_account_email = "provisioner@my-gcp-project.iam.gserviceaccount.com"
  existing_custom_role_id        = "projects/my-gcp-project/roles/DbxProvisioner"
}

run "references_identity_and_creates_bindings" {
  command = plan

  assert {
    condition     = google_project_iam_member.this.role == var.existing_custom_role_id && google_project_iam_member.this.member == "serviceAccount:provisioner@my-gcp-project.iam.gserviceaccount.com"
    error_message = "The existing role must be bound to the existing service account"
  }
  assert {
    condition     = databricks_user.this.user_name == var.existing_service_account_email && databricks_user_role.this.role == "account_admin"
    error_message = "The existing identity must be registered as a Databricks account admin"
  }
  assert {
    condition     = output.service_account_unique_id == "123456789012345678901"
    error_message = "The existing identity attributes must be returned"
  }
}
