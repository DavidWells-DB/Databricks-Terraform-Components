data "aws_iam_role" "this" {
  name = element(split("/", var.existing_role_arn), length(split("/", var.existing_role_arn)) - 1)

  lifecycle {
    postcondition {
      condition     = self.arn == var.existing_role_arn
      error_message = "The resolved IAM role ARN does not match existing_role_arn. Check the role path and ARN."
    }
  }
}

resource "databricks_mws_credentials" "this" {
  provider = databricks.account

  credentials_name = coalesce(var.credentials_name, "${var.resource_prefix}-creds")
  role_arn         = data.aws_iam_role.this.arn
}
