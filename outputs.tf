output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "web_app_url" {
  description = "URL of the web app"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "blob_container_url" {
  description = "URL of the blob container"
  value       = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/${azurerm_storage_container.images.name}"
}

output "sample_image_url" {
  description = "URL of the sample image in blob storage"
  value       = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/${azurerm_storage_container.images.name}/${azurerm_storage_blob.sample_image.name}"
}
