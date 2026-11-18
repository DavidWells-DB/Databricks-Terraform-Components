mock_provider "aws" {
  mock_data "aws_s3_bucket" {
    defaults = {
      id                          = "existing-root-bucket"
      arn                         = "arn:aws:s3:::existing-root-bucket"
      bucket_regional_domain_name = "existing-root-bucket.s3.us-east-1.amazonaws.com"
    }
  }
}

mock_provider "databricks" {
  alias = "account"
}

variables {
  databricks_account_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  resource_prefix       = "acme"
  existing_bucket_name  = "existing-root-bucket"
}

run "references_bucket_and_creates_registration" {
  command = plan

  variables {
    storage_configuration_name = "customer-storage"
  }

  assert {
    condition     = databricks_mws_storage_configurations.this.bucket_name == "existing-root-bucket"
    error_message = "The registration must reference the existing bucket"
  }
  assert {
    condition     = databricks_mws_storage_configurations.this.storage_configuration_name == "customer-storage" && output.bucket_arn == "arn:aws:s3:::existing-root-bucket"
    error_message = "The registration name must be configurable and bucket attributes must come from the data source"
  }
}
