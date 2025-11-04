terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Storage Account for blob storage
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = var.tags
}

# Blob container for images
resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
  
  tags = var.tags
}

# App Service (Web App)
resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = false
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "STORAGE_ACCOUNT_NAME"         = azurerm_storage_account.main.name
    "BLOB_CONTAINER_URL"           = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/${azurerm_storage_container.images.name}"
  }

  tags = var.tags
}

# Upload sample image to blob storage
resource "azurerm_storage_blob" "sample_image" {
  name                   = "sample-image.jpg"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.images.name
  type                   = "Block"
  source                 = "${path.module}/assets/sample-image.jpg"
}
