#!/bin/bash
set -e

echo "==================================="
echo "Azure Web App Deployment Script"
echo "==================================="
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Error: Azure CLI is not installed. Please install it first."
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform is not installed. Please install it first."
    exit 1
fi

# Check if logged into Azure
echo "Checking Azure authentication..."
if ! az account show &> /dev/null; then
    echo "Not logged into Azure. Please run 'az login' first."
    exit 1
fi

echo "✓ Azure authentication verified"
echo ""

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

echo ""
echo "Planning Terraform deployment..."
terraform plan -out=tfplan

echo ""
read -p "Do you want to apply this plan? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled."
    exit 0
fi

echo ""
echo "Applying Terraform configuration..."
terraform apply tfplan

echo ""
echo "✓ Infrastructure deployed successfully!"
echo ""

# Get outputs
WEB_APP_URL=$(terraform output -raw web_app_url 2>/dev/null || echo "")
BLOB_CONTAINER_URL=$(terraform output -raw blob_container_url 2>/dev/null || echo "")
IMAGE_URL=$(terraform output -raw sample_image_url 2>/dev/null || echo "")
RESOURCE_GROUP=$(terraform output -raw resource_group_name 2>/dev/null || echo "")

if [ -n "$WEB_APP_URL" ]; then
    echo "Deployment Information:"
    echo "======================="
    echo "Web App URL: $WEB_APP_URL"
    echo "Blob Container URL: $BLOB_CONTAINER_URL"
    echo "Sample Image URL: $IMAGE_URL"
    echo ""
    
    # Extract app name from URL
    APP_NAME=$(echo "$WEB_APP_URL" | cut -d'/' -f3 | cut -d'.' -f1)
    
    echo "Deploying web application files..."
    
    # Update config.js with actual blob container URL
    echo "Updating configuration with blob container URL..."
    # Use cross-platform sed compatible approach
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|BLOB_CONTAINER_URL_PLACEHOLDER|${BLOB_CONTAINER_URL}|g" webapp/config.js
    else
        sed -i "s|BLOB_CONTAINER_URL_PLACEHOLDER|${BLOB_CONTAINER_URL}|g" webapp/config.js
    fi
    
    cd webapp
    zip -q -r ../webapp.zip .
    cd ..
    
    az webapp deployment source config-zip \
        --resource-group "$RESOURCE_GROUP" \
        --name "$APP_NAME" \
        --src webapp.zip
    
    rm webapp.zip
    
    # Restore the placeholder in config.js
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|${BLOB_CONTAINER_URL}|BLOB_CONTAINER_URL_PLACEHOLDER|g" webapp/config.js
    else
        sed -i "s|${BLOB_CONTAINER_URL}|BLOB_CONTAINER_URL_PLACEHOLDER|g" webapp/config.js
    fi
    
    echo ""
    echo "✓ Web application deployed successfully!"
    echo ""
    echo "You can now access your web app at: $WEB_APP_URL"
else
    echo "Warning: Could not retrieve deployment information."
fi

echo ""
echo "Deployment complete!"
