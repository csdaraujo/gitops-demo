provider "azurerm" {
  features {}
}

data "azurerm_container_registry" "acr" {
  name                = var.acr.name
  resource_group_name = var.acr.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.env}-gitops-demo"
  location = "Central US"
}

resource "azurerm_app_service_plan" "plan" {
  name = "plan-${var.env}-gitops-demo"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Basic"
    size = "B1"
  }

  kind     = "Linux"
  reserved = true
}

resource "azurerm_app_service" "app" {
  name = "app-${var.env}-gitops-demo"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|${data.azurerm_container_registry.acr.name}.azurecr.io/demo-api:changeme"
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = data.azurerm_container_registry.acr.login_server
    "DOCKER_REGISTRY_SERVER_USERNAME" = data.azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = data.azurerm_container_registry.acr.admin_password
    "PORT"                            = "8080"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      site_config["linux_fx_version"]
    ]
  }
}
