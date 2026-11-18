data "aws_s3_bucket" "this" {
  bucket = var.existing_bucket_name
}

resource "databricks_mws_storage_configurations" "this" {
  provider = databricks.account

  account_id                 = var.databricks_account_id
  storage_configuration_name = coalesce(var.storage_configuration_name, "${var.resource_prefix}-storage")
  bucket_name                = data.aws_s3_bucket.this.id
}
