# Azure Web App with Blob Storage Demo

This repository contains infrastructure as code (Terraform) to deploy a simple HTML web page on Azure App Service with an image hosted in Azure Blob Storage.

## Architecture

- **Azure App Service**: Hosts the static HTML page
- **Azure Storage Account**: Stores the image in blob storage with public access
- **Azure Resource Group**: Contains all resources
- **Multi-region ready**: Infrastructure is designed to be easily replicated across regions

## Prerequisites

- Azure CLI installed and authenticated
- Terraform >= 1.0 installed
- An active Azure subscription

## Structure

```
.
├── main.tf              # Main Terraform configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── webapp/
│   └── index.html      # HTML page to be deployed
├── assets/
│   └── sample-image.jpg # Sample image for blob storage
└── README.md           # This file
```

## Deployment Steps

### 1. Authenticate with Azure

```bash
az login
az account set --subscription "<your-subscription-id>"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply the Configuration

```bash
terraform apply
```

When prompted, type `yes` to confirm the deployment.

### 5. Get the Output URLs

After successful deployment, Terraform will output:
- Web App URL
- Blob Container URL
- Sample Image URL

### 6. Deploy the HTML Page

After infrastructure is created, deploy the HTML page to the App Service:

```bash
# Get the app name from Terraform output
APP_NAME=$(terraform output -raw web_app_url | cut -d'/' -f3 | cut -d'.' -f1)

# Deploy using Azure CLI
cd webapp
zip -r ../webapp.zip .
cd ..
az webapp deployment source config-zip --resource-group rg-webapp-demo --name $APP_NAME --src webapp.zip
```

## Configuration

You can customize the deployment by modifying `variables.tf` or by creating a `terraform.tfvars` file:

```hcl
resource_group_name   = "my-rg-webapp"
location              = "westus"
storage_account_name  = "mystorageaccount"
app_service_name      = "my-webapp"
```

**Note**: Storage account names and app service names must be globally unique across Azure.

## Accessing the Application

After deployment, visit the Web App URL provided in the Terraform outputs. The page will display with the image loaded from Azure Blob Storage.

## Multi-Region Expansion

To deploy to multiple regions:

1. Create a new Terraform workspace or module for each region
2. Update the `location` variable
3. Ensure globally unique names for storage accounts and app services
4. Consider adding Azure Front Door or Traffic Manager for global load balancing

## Clean Up

To remove all resources:

```bash
terraform destroy
```

## Security Notes

- The blob container is set to public access level "blob" to allow direct image access
- For production, consider using Azure CDN or SAS tokens for more secure access
- Review and adjust Network Security Groups as needed

## Future Enhancements

- Add Azure Front Door for multi-region load balancing
- Implement Azure CDN for improved performance
- Add SSL/TLS certificates
- Implement authentication if needed
- Add monitoring and logging with Application Insights