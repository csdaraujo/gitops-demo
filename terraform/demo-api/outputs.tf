output "acr_url" {
  value = data.azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = data.azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value     = data.azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "app_url" {
  value = azurerm_app_service.app.default_site_hostname
}
