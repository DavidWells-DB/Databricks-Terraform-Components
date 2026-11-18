terraform {
  required_version = ">= 1.7"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # The pinned private-endpoints module targets the azurerm 3.x/4.x API.
      version = ">= 3.70, < 5.0"
    }
    databricks = {
      source                = "databricks/databricks"
      version               = ">= 1.50"
      configuration_aliases = [databricks.account]
    }
  }
}
