data "google_service_account" "this" {
  account_id = var.existing_service_account_email
  project    = var.project_id
}

resource "google_project_iam_member" "this" {
  project = var.project_id
  role    = var.existing_custom_role_id
  member  = "serviceAccount:${data.google_service_account.this.email}"
}

resource "databricks_user" "this" {
  provider  = databricks.account
  user_name = data.google_service_account.this.email
}

resource "databricks_user_role" "this" {
  provider = databricks.account
  user_id  = databricks_user.this.id
  role     = "account_admin"
}
