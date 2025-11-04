variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-webapp-demo"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique, 3-24 lowercase alphanumeric characters)"
  type        = string
  default     = "stwebappdemo"
  
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 characters, lowercase letters and numbers only."
  }
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "asp-webapp-demo"
}

variable "app_service_name" {
  description = "Name of the App Service (must be globally unique, alphanumeric and hyphens)"
  type        = string
  default     = "app-webapp-demo"
  
  validation {
    condition     = can(regex("^[a-z0-9-]{1,60}$", var.app_service_name))
    error_message = "App Service name must be 1-60 characters, lowercase letters, numbers, and hyphens only."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Demo"
    Project     = "WebApp"
    ManagedBy   = "Terraform"
  }
}
