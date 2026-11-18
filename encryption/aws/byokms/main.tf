data "aws_kms_key" "managed_services" {
  key_id = var.existing_managed_services_key_arn
}

data "aws_kms_key" "workspace_storage" {
  key_id = var.existing_workspace_storage_key_arn
}

resource "databricks_mws_customer_managed_keys" "managed_services" {
  provider = databricks.account

  account_id = var.databricks_account_id

  aws_key_info {
    key_arn   = data.aws_kms_key.managed_services.arn
    key_alias = var.existing_managed_services_key_alias
  }

  use_cases = ["MANAGED_SERVICES"]
}

resource "databricks_mws_customer_managed_keys" "workspace_storage" {
  provider = databricks.account

  account_id = var.databricks_account_id

  aws_key_info {
    key_arn   = data.aws_kms_key.workspace_storage.arn
    key_alias = var.existing_workspace_storage_key_alias
  }

  use_cases = ["STORAGE"]
}
