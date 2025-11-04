# Quick Start Guide

This guide will help you quickly deploy the Azure Web App with Blob Storage.

## Prerequisites

Before you begin, ensure you have:
- Azure CLI installed
- Terraform installed (version 1.0 or later)
- An active Azure subscription

## Quick Deployment (3 Steps)

### Step 1: Authenticate with Azure

```bash
az login
```

### Step 2: Customize Variables (Optional)

Copy the example file and edit with your preferred values:

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your preferred values
```

**Important**: Storage account names and App Service names must be globally unique across all of Azure. If deployment fails due to name conflicts, update these values in `terraform.tfvars`:

```hcl
storage_account_name = "myuniquestorage123"
app_service_name     = "myuniquewebapp123"
```

### Step 3: Run the Deployment Script

```bash
./deploy.sh
```

The script will:
1. Initialize Terraform
2. Create a deployment plan
3. Ask for confirmation
4. Deploy all infrastructure
5. Upload the web application
6. Display the web app URL

## Accessing Your Application

After deployment completes, you'll see output like:

```
Web App URL: https://app-webapp-demo.azurewebsites.net
```

Visit this URL in your browser to see your deployed application with the image from blob storage!

## Manual Deployment (Alternative)

If you prefer to run commands manually:

```bash
# 1. Initialize Terraform
terraform init

# 2. Plan the deployment
terraform plan

# 3. Apply the configuration
terraform apply

# 4. Deploy the web app
cd webapp
zip -r ../webapp.zip .
cd ..

APP_NAME=$(terraform output -raw web_app_url | cut -d'/' -f3 | cut -d'.' -f1)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)

az webapp deployment source config-zip \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --src webapp.zip
```

## Cleanup

To remove all resources and avoid charges:

```bash
terraform destroy
```

Type `yes` when prompted to confirm deletion.

## Troubleshooting

### Name Already Exists Error

If you see errors about names already being taken, edit `terraform.tfvars`:

```hcl
storage_account_name = "stwebapp$(date +%s)"  # Add timestamp
app_service_name     = "webapp$(date +%s)"     # Add timestamp
```

### Image Not Loading

The image may take a few minutes to become accessible after deployment. Refresh the page after waiting a minute.

### Deployment Timeout

If the deployment times out, you can check status with:

```bash
terraform show
```

And retry with:

```bash
terraform apply
```

## Next Steps

- Configure a custom domain
- Add SSL certificate
- Deploy to multiple regions
- Set up Azure Front Door for global load balancing
- Add Application Insights for monitoring

For detailed information, see the main [README.md](README.md).
