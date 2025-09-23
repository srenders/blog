# Power BI Monitor for Business Central

A comprehensive Business Central extension that enables seamless monitoring and management of Microsoft Power BI resources, allowing you to synchronize, track, and monitor Power BI workspaces, datasets, and dataflows directly from Business Central.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Architecture](#architecture)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

The Power BI Monitor extension bridges Business Central and Power BI, providing:

- **Centralized Monitoring**: Monitor all Power BI resources from within Business Central
- **Automated Synchronization**: Keep BC data in sync with Power BI content
- **Performance Analytics**: Track refresh performance and status
- **User-Friendly Setup**: Guided wizard for easy configuration
- **Enterprise Security**: OAuth 2.0 authentication with Azure AD

## ✨ Features

### 🏢 Workspace Management
- Synchronize Power BI workspaces
- View workspace details and access rights
- Navigate directly to Power BI portal

### 📊 Dataset Management
- List and manage datasets across workspaces
- Trigger dataset refreshes
- Monitor refresh status and performance
- Track refresh history and statistics
- Bulk refresh operations

### 🔄 Dataflow Management
- View and manage Power BI dataflows
- Trigger dataflow refreshes
- Monitor refresh transactions
- Performance tracking and reporting

### 📈 Reporting & Analytics
- Dataset refresh performance metrics
- Success/failure rate tracking
- Duration statistics and trends
- Comprehensive overview dashboards

### 🛠️ Administration
- **Setup Wizard**: Step-by-step guided configuration
- **Advanced Setup**: Direct configuration for power users
- **Auto-Sync**: Scheduled automatic synchronization
- **Role Center**: Dedicated Power BI management interface

## 📋 Prerequisites

### Technical Requirements
- **Business Central**: Version 26.0 or later
- **Power BI Pro License**: Required for API access
- **Azure AD**: Admin access for app registration
- **Permissions**: Ability to register applications in Azure AD

### Power BI Requirements
- Power BI workspace(s) with content
- Service Principal access to workspaces (recommended)
- Admin consent for API permissions

## 🚀 Installation

### 1. Install the Extension
```
1. Download the .app file
2. Install via Business Central Extension Management
3. Refresh your browser/client
```

### 2. Initial Setup
Choose one of two setup methods:

#### Option A: Guided Setup Wizard (Recommended)
1. Go to **Assisted Setup** in Business Central
2. Find "Power BI Monitor Setup"
3. Follow the step-by-step wizard

#### Option B: Manual Setup
1. Navigate to **Power BI Setup** page
2. Configure authentication manually
3. Test the connection

## ⚙️ Configuration

### Azure AD Application Setup

#### 1. Register Application
```
1. Go to Azure Portal (portal.azure.com)
2. Navigate to Azure Active Directory > App registrations
3. Click "New registration"
4. Name: "Business Central Power BI Monitor"
5. Account type: "Accounts in this organizational directory only"
6. Click "Register"
```

#### 2. Configure API Permissions
Add the following **Application permissions** for **Power BI Service**:
- `Dataset.Read.All` - Read dataset metadata
- `Dataset.ReadWrite.All` - Trigger dataset refreshes
- `Dataflow.Read.All` - Read dataflow metadata
- `Dataflow.ReadWrite.All` - Trigger dataflow refreshes
- `Group.Read.All` - Access workspace information
- `Workspace.Read.All` - Read workspace metadata

**Important**: Grant admin consent for all permissions.

#### 3. Create Client Secret
```
1. Go to "Certificates & secrets"
2. Click "New client secret"
3. Set appropriate expiration
4. Copy the secret value immediately
```

#### 4. Configure Business Central
Enter the following in Power BI Setup:
- **Client ID**: Application (client) ID
- **Client Secret**: Secret value from step 3
- **Tenant ID**: Directory (tenant) ID
- **Authority URL**: `https://login.microsoftonline.com/`
- **Power BI API URL**: `https://api.powerbi.com/v1.0/myorg/`

## 📖 Usage

### Getting Started

1. **Initial Synchronization**
   ```
   Power BI Workspaces → Actions → Refresh All Workspaces
   ```

2. **View Datasets**
   ```
   Power BI Datasets → Review synchronized datasets
   ```

3. **Trigger Refreshes**
   ```
   Power BI Datasets → Actions → Refresh Selected Dataset
   ```

### Daily Operations

#### Workspace Management
- **View All Workspaces**: Navigate to "Power BI Workspaces"
- **Refresh Workspace Data**: Use "Refresh All Workspaces" action
- **Access Workspace**: Click "Open in Power BI" to navigate to portal

#### Dataset Operations
- **Bulk Refresh**: Select multiple datasets and use "Refresh Selected Datasets"
- **Monitor Status**: Check "Last Refresh Status" column
- **View Performance**: Review "Average Refresh Duration" metrics
- **Check History**: Use "Get Refresh History" action for detailed logs

#### Dataflow Operations
- **View Dataflows**: Navigate to "Power BI Dataflows"
- **Refresh Dataflows**: Use individual or bulk refresh actions
- **Monitor Transactions**: Check refresh status and duration

### Automation

#### Auto-Sync Setup
```
1. Power BI Setup → Actions → Manage Auto Sync
2. Enable automatic synchronization
3. Configure schedule (default: every 30 minutes)
4. Monitor job queue entry status
```

#### Scheduled Refreshes
Configure dataset refreshes to run automatically:
```
1. Power BI Datasets → Select dataset
2. Actions → Schedule Refresh (requires custom implementation)
```

## 🏗️ Architecture

### Component Overview

#### Core Tables
- **Power BI Setup** (90110): Configuration and authentication
- **Power BI Workspace** (90111): Workspace information
- **Power BI Dataset** (90112): Dataset metadata and metrics
- **Power BI Dataflow** (90113): Dataflow information
- **Power BI Report** (90114): Report metadata

#### Management Codeunits
- **Power BI API Management** (90110): Main orchestrator
- **Power BI Authentication** (90130): OAuth token management
- **Power BI Http Client** (90131): HTTP communication
- **Power BI Json Processor** (90132): JSON parsing utilities
- **Power BI Dataset Manager** (90133): Dataset operations
- **Power BI Auto Sync** (90120): Automation functionality

#### User Interface
- **Pages**: Management interfaces for each resource type
- **Role Center**: Dedicated Power BI management workspace
- **Setup Wizard**: Guided configuration experience
- **Overview Pages**: Dashboard-style summaries

### Data Flow
```
Business Central → Azure AD → Power BI REST API
     ↓               ↓              ↓
Authentication → HTTP Client → JSON Processing
     ↓               ↓              ↓
Token Caching → Response → Database Storage
```

### Security Architecture
- **OAuth 2.0**: Client credentials flow
- **Token Caching**: 50-minute cache duration
- **Secret Storage**: Encrypted in BC database
- **API Permissions**: Principle of least privilege

## 🔒 Security

### Authentication
- Uses OAuth 2.0 client credentials flow
- Tokens cached for 50 minutes to minimize API calls
- Automatic token refresh when expired

### Data Protection
- Client secrets encrypted in Business Central
- API communications over HTTPS only
- No Power BI data stored permanently in BC

### Access Control
- Respects Business Central user permissions
- Power BI workspace access controlled by Power BI
- Service principal recommended for production

### Best Practices
- Rotate client secrets regularly
- Monitor token usage and API limits
- Use dedicated service accounts
- Implement proper backup procedures

## 🛠️ Troubleshooting

### Common Issues

#### Authentication Failures
**Symptoms**: "Authentication failed" messages
**Solutions**:
- Verify client ID, secret, and tenant ID
- Check admin consent was granted
- Ensure client secret hasn't expired
- Validate Azure AD app permissions

#### API Permission Errors
**Symptoms**: "Forbidden" or "Unauthorized" errors
**Solutions**:
- Grant admin consent for all required permissions
- Verify service principal has workspace access
- Check Power BI admin settings don't block service principals

#### Synchronization Issues
**Symptoms**: Missing workspaces or datasets
**Solutions**:
- Verify workspace membership/access
- Check Power BI admin policies
- Review service principal workspace permissions
- Test with user account first

#### Network Connectivity
**Symptoms**: "HTTP Send failed" errors
**Solutions**:
- Check internet connectivity
- Verify firewall allows HTTPS to Azure/Power BI
- Test from Business Central server directly
- Review proxy settings if applicable

### Diagnostic Steps

1. **Test Authentication**
   ```
   Power BI Setup → Actions → Test Connection
   ```

2. **Check Configuration**
   ```
   Power BI Setup → Verify all fields completed
   ```

3. **Review Azure AD App**
   ```
   Azure Portal → App registrations → Your app
   Check permissions and secrets
   ```

4. **Validate Power BI Access**
   ```
   Test with same credentials in Power BI portal
   Verify workspace access
   ```

### Error Codes

| Code | Description | Solution |
|------|-------------|----------|
| 400 | Bad Request | Check request parameters |
| 401 | Unauthorized | Verify authentication |
| 403 | Forbidden | Check permissions |
| 404 | Not Found | Verify resource exists |
| 429 | Rate Limited | Reduce API call frequency |
| 500 | Server Error | Retry later or contact support |

## 📚 API Reference

### Main Procedures

#### Power BI API Management
```al
procedure SynchronizeWorkspaces(): Boolean
procedure SynchronizeDatasets(WorkspaceId: Guid): Boolean
procedure TriggerDatasetRefresh(WorkspaceId: Guid; DatasetId: Guid): Boolean
procedure GetDatasetRefreshHistory(WorkspaceId: Guid; DatasetId: Guid): Boolean
```

#### Authentication
```al
procedure GetAuthToken(): Text
procedure RefreshToken(): Boolean
procedure ValidateConfiguration(): Boolean
```

#### Dataset Management
```al
procedure SynchronizeDatasets(WorkspaceId: Guid): Boolean
procedure TriggerDatasetRefresh(WorkspaceId: Guid; DatasetId: Guid): Boolean
procedure GetRefreshableDatasets(WorkspaceId: Guid; var RefreshableDatasets: Record "Power BI Dataset"): Integer
```

### Events

#### Setup Events
```al
OnAfterPowerBISetup()
OnBeforeAuthentication()
OnAfterSuccessfulConnection()
```

#### Synchronization Events
```al
OnBeforeWorkspaceSync()
OnAfterWorkspaceSync()
OnBeforeDatasetSync()
OnAfterDatasetSync()
```

## 🤝 Contributing

### Development Setup
1. Clone the repository
2. Install AL Language extension
3. Configure launch.json for your BC environment
4. Download symbols and compile

### Code Standards
- Follow AL coding guidelines
- Include comprehensive documentation
- Write unit tests for new functionality
- Use meaningful variable and procedure names

### Pull Request Process
1. Create feature branch
2. Implement changes with tests
3. Update documentation
4. Submit pull request with description

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

### Getting Help
- **Documentation**: Check this README and inline help
- **Issues**: Report bugs via GitHub issues
- **Questions**: Use GitHub discussions

### Commercial Support
For enterprise support and customization:
- Contact: [Your Contact Information]
- Email: [Your Email]
- Website: [Your Website]

---

## 📊 Quick Start Checklist

- [ ] Install the extension
- [ ] Register Azure AD application
- [ ] Configure API permissions
- [ ] Create client secret
- [ ] Run setup wizard
- [ ] Test connection
- [ ] Synchronize workspaces
- [ ] Verify dataset access
- [ ] Test refresh operations
- [ ] Enable auto-sync (optional)

## 🎯 What's Next?

After setup, explore these features:
1. **Dashboard Views**: Check the overview pages for insights
2. **Performance Monitoring**: Review refresh metrics
3. **Automation**: Set up scheduled synchronization
4. **Custom Reports**: Build reports using the synchronized data
5. **Advanced Configuration**: Explore additional settings

---

**Power BI Monitor v1.0.0** | Built with ❤️ for Business Central