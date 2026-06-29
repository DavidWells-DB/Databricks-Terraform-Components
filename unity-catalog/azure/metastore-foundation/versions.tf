terraform {
  required_version = ">= 1.7"

  required_providers {
    databricks = {
      source                = "databricks/databricks"
      version               = ">= 1.50"
      configuration_aliases = [databricks.account, databricks.workspace]
    }
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.70"
      configuration_aliases = [azurerm]
    }
  }
}
