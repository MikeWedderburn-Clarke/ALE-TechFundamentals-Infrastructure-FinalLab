#!/bin/bash
# Deployment script for Azure App Service infrastructure

# Variables
RESOURCE_GROUP_NAME="rg-aletechfund-prod"
LOCATION="uksouth"
TEMPLATE_FILE="main.bicep"
PARAMETERS_FILE="main.parameters.json"

# Display deployment information
echo "======================================"
echo "Azure App Service Deployment Script"
echo "======================================"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Primary Location: $LOCATION"
echo "Template: $TEMPLATE_FILE"
echo "Parameters: $PARAMETERS_FILE"
echo "======================================"
echo ""

# Check if Azure CLI is logged in
echo "Checking Azure CLI authentication..."
az account show > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Not logged in to Azure CLI. Please run 'az login' first."
    exit 1
fi

echo "✓ Azure CLI authenticated"
echo ""

# Create resource group if it doesn't exist
echo "Creating resource group if it doesn't exist..."
az group create \
    --name "$RESOURCE_GROUP_NAME" \
    --location "$LOCATION" \
    --output table

echo ""

# Deploy Bicep template
echo "Deploying Bicep template..."
az deployment group create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --parameters "$PARAMETERS_FILE" \
    --output table

if [ $? -eq 0 ]; then
    echo ""
    echo "======================================"
    echo "✓ Deployment completed successfully!"
    echo "======================================"
    echo ""
    
    # Get deployment outputs
    echo "Deployment outputs:"
    az deployment group show \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name main \
        --query properties.outputs \
        --output table
else
    echo ""
    echo "======================================"
    echo "✗ Deployment failed!"
    echo "======================================"
    exit 1
fi
