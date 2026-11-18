mock_provider "aws" {
  mock_data "aws_kms_key" {
    defaults = {
      arn = "arn:aws:kms:us-east-1:123456789012:key/123e4567-e89b-12d3-a456-426614174000"
    }
  }
}

mock_provider "databricks" {
  alias = "account"
}

variables {
  databricks_account_id                = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  existing_managed_services_key_arn    = "arn:aws:kms:us-east-1:123456789012:key/123e4567-e89b-12d3-a456-426614174000"
  existing_managed_services_key_alias  = "alias/existing-managed"
  existing_workspace_storage_key_arn   = "arn:aws:kms:us-east-1:123456789012:key/22222222-2222-4222-8222-222222222222"
  existing_workspace_storage_key_alias = "alias/existing-storage"
}

override_data {
  target = data.aws_kms_key.workspace_storage
  values = {
    arn = "arn:aws:kms:us-east-1:123456789012:key/22222222-2222-4222-8222-222222222222"
  }
}

run "references_keys_and_creates_registrations" {
  command = plan

  assert {
    condition     = databricks_mws_customer_managed_keys.managed_services.aws_key_info[0].key_arn == var.existing_managed_services_key_arn
    error_message = "The managed-services registration must use the existing key"
  }
  assert {
    condition     = databricks_mws_customer_managed_keys.workspace_storage.aws_key_info[0].key_arn == var.existing_workspace_storage_key_arn
    error_message = "The storage registration must use the existing key"
  }
  assert {
    condition     = output.managed_services_key_alias == "alias/existing-managed" && output.workspace_storage_key_alias == "alias/existing-storage"
    error_message = "The existing aliases must reach the resolved output contract"
  }
}
