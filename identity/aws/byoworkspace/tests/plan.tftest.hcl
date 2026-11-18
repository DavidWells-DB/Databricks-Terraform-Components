mock_provider "aws" {
  mock_data "aws_iam_role" {
    defaults = {
      arn  = "arn:aws:iam::123456789012:role/existing-databricks"
      name = "existing-databricks"
    }
  }
}

mock_provider "databricks" {
  alias = "account"
}

variables {
  resource_prefix   = "acme"
  existing_role_arn = "arn:aws:iam::123456789012:role/existing-databricks"
}

run "references_role_and_creates_registration" {
  command = plan

  variables {
    credentials_name = "customer-credentials"
  }

  assert {
    condition     = databricks_mws_credentials.this.role_arn == var.existing_role_arn
    error_message = "The registration must reference the existing role ARN"
  }
  assert {
    condition     = databricks_mws_credentials.this.credentials_name == "customer-credentials" && output.role_name == "existing-databricks"
    error_message = "The registration name must be configurable and the existing role must be read"
  }
}
