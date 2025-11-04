# ALE-TechFundamentals-Infrastructure-FinalLab

This repository contains a simple static HTML application and Azure infrastructure as code (Bicep) to deploy it to Azure App Service in UK South and UK West regions.

## Architecture

The infrastructure deploys:
- **2 App Service Plans** (one in UK South, one in UK West)
- **2 App Service Web Apps** (one in each region)
- Both services are configured with:
  - Linux hosting
  - Node.js 18 LTS runtime
  - HTTPS enforcement
  - Basic (B1) tier for cost-effective hosting

## Prerequisites

- Azure CLI installed ([Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- Azure subscription with appropriate permissions
- Bicep CLI (bundled with Azure CLI 2.20.0+)

## Quick Start

### 1. Login to Azure

```bash
az login
```

### 2. Deploy Infrastructure

Using the deployment script:

```bash
./deploy.sh
```

Or manually:

```bash
# Create resource group
az group create --name rg-aletechfund-prod --location uksouth

# Deploy Bicep template
az deployment group create \
  --resource-group rg-aletechfund-prod \
  --template-file main.bicep \
  --parameters main.parameters.json
```

### 3. Deploy Application

After infrastructure is deployed, deploy the index.html file to both App Service instances:

```bash
# Deploy to UK South
az webapp up --name aletechfund-app-uksouth-prod --resource-group rg-aletechfund-prod --html

# Deploy to UK West  
az webapp up --name aletechfund-app-ukwest-prod --resource-group rg-aletechfund-prod --html
```

Or use zip deployment:

```bash
# Create deployment package
zip deploy.zip index.html

# Deploy to UK South
az webapp deployment source config-zip \
  --resource-group rg-aletechfund-prod \
  --name aletechfund-app-uksouth-prod \
  --src deploy.zip

# Deploy to UK West
az webapp deployment source config-zip \
  --resource-group rg-aletechfund-prod \
  --name aletechfund-app-ukwest-prod \
  --src deploy.zip
```

## Configuration

The deployment can be customized by modifying `main.parameters.json`:

- `baseName`: Base name for all resources (default: "aletechfund")
- `environment`: Environment name (default: "prod")
- `locationUKSouth`: Azure region for UK South (default: "uksouth")
- `locationUKWest`: Azure region for UK West (default: "ukwest")
- `appServicePlanSku`: App Service Plan SKU (default: "B1")

## Files

- `main.bicep` - Main Bicep infrastructure template
- `main.parameters.json` - Parameters file for customization
- `deploy.sh` - Automated deployment script
- `index.html` - Static HTML application to deploy

## Validation

To validate the Bicep template without deploying:

```bash
az bicep build --file main.bicep
```

To perform a what-if deployment:

```bash
az deployment group what-if \
  --resource-group rg-aletechfund-prod \
  --template-file main.bicep \
  --parameters main.parameters.json
```

## Clean Up

To remove all deployed resources:

```bash
az group delete --name rg-aletechfund-prod --yes
```

## Accessing the Application

After deployment, the applications will be available at:
- UK South: `https://aletechfund-app-uksouth-prod.azurewebsites.net`
- UK West: `https://aletechfund-app-ukwest-prod.azurewebsites.net`