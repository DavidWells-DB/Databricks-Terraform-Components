terraform {
  required_version = ">= 1.7"

  required_providers {
    databricks = {
      source                = "databricks/databricks"
      version               = ">= 1.50"
      configuration_aliases = [databricks.workspace]
    }
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.0"
      configuration_aliases = [aws]
    }
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.70"
      configuration_aliases = [azurerm]
    }
    google = {
      source                = "hashicorp/google"
      version               = ">= 5.0"
      configuration_aliases = [google]
    }
  }
}
