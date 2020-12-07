provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-shared-gitops-demo"
  location = "Central US"
}

resource "azurerm_container_registry" "acr" {
  name                = "acrgitopsdemo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku = "Standard"

  admin_enabled = true
}
