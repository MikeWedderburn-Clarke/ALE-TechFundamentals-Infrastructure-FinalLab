// Main Bicep template for deploying Azure App Service in UK South and UK West
@description('The base name for resources')
param baseName string = 'aletechfund'

@description('The environment name (e.g., dev, prod)')
param environment string = 'prod'

@description('Location for UK South resources')
param locationUKSouth string = 'uksouth'

@description('Location for UK West resources')
param locationUKWest string = 'ukwest'

@description('The SKU for the App Service Plan')
param appServicePlanSku string = 'B1'

@description('The tier for the App Service Plan')
param appServicePlanTier string = 'Basic'

// Variables
var appServicePlanNameUKSouth = '${baseName}-asp-${locationUKSouth}-${environment}'
var appServicePlanNameUKWest = '${baseName}-asp-${locationUKWest}-${environment}'
var webAppNameUKSouth = '${baseName}-app-${locationUKSouth}-${environment}'
var webAppNameUKWest = '${baseName}-app-${locationUKWest}-${environment}'

// App Service Plan for UK South
resource appServicePlanUKSouth 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanNameUKSouth
  location: locationUKSouth
  sku: {
    name: appServicePlanSku
    tier: appServicePlanTier
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// App Service Plan for UK West
resource appServicePlanUKWest 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanNameUKWest
  location: locationUKWest
  sku: {
    name: appServicePlanSku
    tier: appServicePlanTier
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// Web App for UK South
resource webAppUKSouth 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppNameUKSouth
  location: locationUKSouth
  properties: {
    serverFarmId: appServicePlanUKSouth.id
    siteConfig: {
      linuxFxVersion: 'NODE|18-lts'
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '18-lts'
        }
      ]
    }
    httpsOnly: true
  }
}

// Web App for UK West
resource webAppUKWest 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppNameUKWest
  location: locationUKWest
  properties: {
    serverFarmId: appServicePlanUKWest.id
    siteConfig: {
      linuxFxVersion: 'NODE|18-lts'
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '18-lts'
        }
      ]
    }
    httpsOnly: true
  }
}

// Outputs
output webAppUKSouthName string = webAppUKSouth.name
output webAppUKWestName string = webAppUKWest.name
output webAppUKSouthUrl string = 'https://${webAppUKSouth.properties.defaultHostName}'
output webAppUKWestUrl string = 'https://${webAppUKWest.properties.defaultHostName}'
output webAppUKSouthHostName string = webAppUKSouth.properties.defaultHostName
output webAppUKWestHostName string = webAppUKWest.properties.defaultHostName
