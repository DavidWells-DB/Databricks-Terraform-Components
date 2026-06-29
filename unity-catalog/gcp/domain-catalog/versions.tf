terraform {
  required_version = ">= 1.7"

  required_providers {
    databricks = {
      source                = "databricks/databricks"
      version               = ">= 1.50"
      configuration_aliases = [databricks.workspace]
    }
    google = {
      source                = "hashicorp/google"
      version               = ">= 5.0"
      configuration_aliases = [google]
    }
  }
}
