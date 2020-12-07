terraform {
  required_version = "= 0.13.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.38"
    }
  }

  backend "azurerm" {}
}

