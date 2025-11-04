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
  description = "Name of the storage account (must be globally unique)"
  type        = string
  default     = "stwebappdemo"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "asp-webapp-demo"
}

variable "app_service_name" {
  description = "Name of the App Service (must be globally unique)"
  type        = string
  default     = "app-webapp-demo"
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
