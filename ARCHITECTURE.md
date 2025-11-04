# Architecture Overview

## Current Architecture (Single Region)

```
┌─────────────────────────────────────────────────────────────────┐
│                         Azure Subscription                       │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                     Resource Group                          │ │
│  │                   (rg-webapp-demo)                         │ │
│  │                                                             │ │
│  │  ┌──────────────────────────┐    ┌────────────────────┐  │ │
│  │  │   Storage Account        │    │  App Service Plan  │  │ │
│  │  │   (stwebappdemo)        │    │  (asp-webapp-demo) │  │ │
│  │  │                          │    │                    │  │ │
│  │  │  ┌────────────────────┐ │    │  ┌──────────────┐ │  │ │
│  │  │  │  Blob Container    │ │    │  │  Web App     │ │  │ │
│  │  │  │  "images"          │ │    │  │ (Linux/Node) │ │  │ │
│  │  │  │                    │ │    │  │              │ │  │ │
│  │  │  │  - sample-image.jpg│◄┼────┼──┤  index.html  │ │  │ │
│  │  │  │  (public access)   │ │    │  │  config.js   │ │  │ │
│  │  │  └────────────────────┘ │    │  └──────────────┘ │  │ │
│  │  └──────────────────────────┘    └────────────────────┘  │ │
│  │                                                             │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTPS
                              ▼
                        ┌──────────┐
                        │  Users   │
                        └──────────┘
```

## Data Flow

1. **User Request**: User navigates to `https://[app-name].azurewebsites.net`
2. **HTML Delivery**: App Service serves `index.html` and `config.js`
3. **Image Request**: Browser requests image from Blob Storage URL
4. **Image Delivery**: Blob Storage serves `sample-image.jpg` directly to user

## Future Multi-Region Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                      Azure Front Door                             │
│                   (Global Load Balancer)                         │
│                                                                   │
│  ┌─────────────┐           ┌─────────────┐                      │
│  │   SSL/TLS   │           │   WAF       │                      │
│  └─────────────┘           └─────────────┘                      │
└─────────────┬────────────────────────────┬───────────────────────┘
              │                            │
    ┌─────────▼─────────┐        ┌────────▼──────────┐
    │   Region 1        │        │   Region 2        │
    │   (East US)       │        │   (West Europe)   │
    │                   │        │                   │
    │  ┌─────────────┐  │        │  ┌─────────────┐ │
    │  │  App Service│  │        │  │  App Service│ │
    │  └─────────────┘  │        │  └─────────────┘ │
    │                   │        │                   │
    │  ┌─────────────┐  │        │  ┌─────────────┐ │
    │  │ Blob Storage│  │        │  │ Blob Storage│ │
    │  │ (with CDN)  │  │        │  │ (with CDN)  │ │
    │  └─────────────┘  │        │  └─────────────┘ │
    └───────────────────┘        └───────────────────┘
```

## Components

### Azure App Service
- **Type**: Linux Web App
- **Runtime**: Node.js 18 LTS
- **Tier**: B1 (Basic)
- **Purpose**: Hosts static HTML page
- **Scaling**: Can be upgraded to Standard tier for auto-scaling

### Azure Storage Account
- **Type**: General Purpose v2
- **Replication**: LRS (Local Redundant Storage)
- **Access**: Public blob access for images
- **Purpose**: Stores static assets (images)

### Blob Container
- **Name**: images
- **Access Level**: Blob (anonymous read access for blobs)
- **Contents**: sample-image.jpg

## Security Considerations

### Current Implementation
- ✅ HTTPS enabled by default on App Service
- ✅ Public blob access for image delivery
- ✅ Managed identities ready for future enhancements
- ✅ Resource tagging for governance

### Production Recommendations
- 🔒 Implement Azure CDN with custom domain
- 🔒 Use SAS tokens for blob access instead of public access
- 🔒 Enable Azure Front Door with WAF
- 🔒 Implement Application Insights for monitoring
- 🔒 Configure custom domains with SSL certificates
- 🔒 Set up Azure Key Vault for secrets management
- 🔒 Enable diagnostic logging

## Scalability & Resilience

### Current Capabilities
- Single region deployment
- Manual scaling of App Service
- LRS storage replication

### Multi-Region Expansion
To expand to multi-region:

1. **Replicate Infrastructure**: Use Terraform workspaces or modules for each region
2. **Add Global Load Balancer**: Deploy Azure Front Door
3. **Upgrade Storage**: Change replication to GRS (Geo-Redundant Storage)
4. **Add CDN**: Implement Azure CDN for blob storage
5. **Database Layer**: If needed, add Azure Cosmos DB for multi-region data
6. **Monitoring**: Set up Application Insights across regions

### Cost Optimization
- Use Azure App Service B1 tier for development
- Upgrade to S1 tier for production with auto-scaling
- Consider Reserved Instances for long-term deployments
- Implement lifecycle management for blob storage

## Network Architecture

```
Internet
   │
   ├──► HTTPS ──► App Service (.azurewebsites.net)
   │                    │
   │                    └──► Serves: index.html, config.js
   │
   └──► HTTPS ──► Blob Storage (.blob.core.windows.net)
                        │
                        └──► Serves: sample-image.jpg
```

## Deployment Pipeline

```
Developer
   │
   └──► git push
           │
           └──► GitHub
                   │
                   └──► [Future: GitHub Actions]
                           │
                           ├──► terraform apply
                           │       │
                           │       └──► Azure Infrastructure
                           │
                           └──► az webapp deploy
                                   │
                                   └──► App Service
```

## Monitoring & Observability

### Available Metrics
- App Service: CPU, Memory, Response Time, HTTP Status
- Storage Account: Transactions, Availability, Latency
- Resource Health: Azure service health status

### Recommended Additions
- Application Insights for application performance monitoring
- Log Analytics workspace for centralized logging
- Azure Monitor alerts for proactive issue detection
- Custom dashboards for operational visibility
