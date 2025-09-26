# Power BI Monitor

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



#### 🏗️ **Architecture Modernization (v1.2.0)**
- **Service-Oriented Design**: Complete migration from monolithic to specialized service architecture
- **Enhanced Error Handling**: Improved error detection with actionable user feedback
- **Zero Breaking Changes**: Seamless upgrade maintaining all existing functionality
- **Better Maintainability**: Clean separation of concerns and modular design

#### 📊 **Enhanced Features**
- **Status Filtering**: Quick filters to show only failed refreshes for troubleshooting
- **Refresh Summary**: Detailed summary views for individual refresh operations
- **Cross-Navigation**: Easy navigation between related pages and data
- **Error Analysis**: Comprehensive error detail viewing for failed operations

#### 🛠️ **Reliability Improvements**
- Fixed GUID comparison issues in dataflow synchronization
- Resolved refresh history data population problems
- Improved error handling for missing or invalid workspace IDs
- Enhanced validation for bulk operations

## �🎯 Overview

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
- **Individual & Bulk Refresh Operations**: Refresh single, selected, or all datasets
- Monitor refresh status and performance in real-time
- **Comprehensive Refresh History**: Detailed tracking of all refresh operations
- Performance metrics with duration statistics and success rates
- **Smart Filtering**: Only refreshable datasets are processed in bulk operations

### 🔄 Dataflow Management
- View and manage Power BI dataflows across workspaces
- **Enhanced Refresh Operations**: Individual, bulk selected, and bulk all refresh capabilities
- **Transaction Monitoring**: Detailed tracking of dataflow refresh transactions
- **Refresh History Management**: Store and analyze complete refresh history
- Performance tracking with duration and error analysis
- Workspace-specific synchronization options

### 📈 Reporting & Analytics
- **Detailed Refresh History Pages**: Comprehensive views with advanced filtering
- **Performance Metrics Dashboard**: Success/failure rates, duration trends, and statistics
- **Error Analysis**: Detailed error information for troubleshooting failed operations
- **Status Filtering**: Quick access to failed operations for immediate attention
- Cross-resource analytics and reporting capabilities

### 🎨 Enhanced User Experience
- **Organized Action Groups**: Logically grouped actions (Refresh, History, Filters)
- **Consistent Interface**: Standardized naming and behavior across all pages
- **Comprehensive Feedback**: Detailed operation results with success/failure counts
- **Smart Confirmations**: Context-aware confirmation dialogs with relevant information
- **Cross-Page Navigation**: Easy navigation between related resources and their history

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
- **Individual Refresh**: "Refresh This Dataset" for single dataset operations
- **Bulk Refresh**: "Refresh Selected Datasets" or "Refresh All Datasets in View"
- **Monitor Status**: Real-time status tracking with "Last Refresh Status" column
- **View Performance**: Review "Average Refresh Duration" and success rate metrics
- **Manage History**: "Update Refresh History" actions (individual, selected, or all)
- **Analyze History**: Navigate to detailed refresh history with filtering options

#### Dataflow Operations
- **View Dataflows**: Navigate to "Power BI Dataflows" with workspace information
- **Synchronization**: "Sync All Dataflows" or "Sync Dataflows for This Workspace"
- **Refresh Operations**: Individual, selected, or bulk refresh capabilities
- **History Management**: Comprehensive refresh history tracking and analysis
- **Monitor Transactions**: Detailed transaction tracking with error analysis

#### Refresh History Analysis
- **Advanced Filtering**: Filter by resource, workspace, status, or show failed operations only
- **Error Details**: View comprehensive error information for failed operations
- **Refresh Summary**: Detailed summary views for individual refresh operations
- **Cross-Navigation**: Easy navigation between history and source resources

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
- **PBI Dataset Refresh History** (90120): Detailed dataset refresh tracking
- **PBI Dataflow Refresh History** (90121): Detailed dataflow refresh tracking

#### Service-Oriented Architecture (v1.2.0+)

**Core Orchestration Layer:**
- **Power BI API Orchestrator** (90120): Clean orchestration layer with improved error handling
- **Power BI Auto Sync** (90121): Automation functionality

**Infrastructure Services:**
- **Power BI Authentication** (90130): OAuth token management
- **Power BI Http Client** (90131): Centralized HTTP communication and authentication
- **Power BI Json Processor** (90132): Reusable JSON parsing utilities

**Specialized Resource Managers:**
- **Power BI Workspace Manager** (90134): Workspace operations and management
- **Power BI Dataset Manager** (90133): Dataset operations and refresh management
- **Power BI Dataflow Manager** (90135): Dataflow operations and transaction tracking
- **Power BI Dashboard Manager** (90136): Dashboard operations and management
- **Power BI Report Manager** (90137): Report operations and management

#### User Interface
- **Resource Management Pages**: Enhanced interfaces for workspaces, datasets, dataflows, and reports
- **Refresh History Pages**: Dedicated pages for detailed refresh history analysis
- **Role Center**: Dedicated Power BI management workspace with quick access to all features
- **Setup Wizard**: Guided configuration experience for easy setup
- **Overview Pages**: Dashboard-style summaries with performance metrics
- **Standardized Actions**: Consistent action grouping and naming across all pages

### Architecture Benefits (v1.2.0+)

**Service-Oriented Design:**
- **Single Responsibility**: Each manager handles one specific Power BI resource type
- **Separation of Concerns**: HTTP, JSON, and business logic cleanly separated
- **Better Error Handling**: Enhanced error detection with actionable user feedback
- **Improved Maintainability**: Smaller, focused components that are easier to test and extend

**Enhanced User Experience:**
- **Consistent Error Messages**: Standardized error handling across all operations
- **Better Success Feedback**: Clear confirmation messages with operation details
- **Actionable Guidance**: Error messages include troubleshooting suggestions

### Data Flow
```
Business Central → PowerBI API Orchestrator → Specialized Managers
     ↓                      ↓                       ↓
PowerBI HTTP Client → Authentication → JSON Processor
     ↓                      ↓                       ↓
Azure AD Token → Power BI REST API → Response Processing
     ↓                      ↓                       ↓
Token Caching → HTTP Response → Database Storage
```

### Migration from Monolithic Architecture
**Previous Architecture (v1.1.0 and earlier):**
- Single 3000+ line codeunit mixing all concerns
- Generic error handling
- Difficult to maintain and extend

**New Architecture (v1.2.0+):**
- Clean service-oriented design with specialized managers
- Enhanced error handling and user feedback
- Modular, extensible, and maintainable
- Zero breaking changes during migration

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

### Recent Fixes

#### GUID Format Error
**Issue**: "Invalid format of GUID string" when syncing dataflows for workspace
**Solution**: Fixed GUID comparison logic in workspace synchronization actions
**Details**: Changed from string comparison (`<> ''`) to proper GUID comparison (`<> EmptyGuid`)

## 📚 API Reference

### Main Procedures

#### Power BI API Orchestrator (New Architecture)
```al
// Core Synchronization Operations
procedure SynchronizeAllData(): Boolean
procedure SynchronizeWorkspaces(): Boolean
procedure SynchronizeDatasets(WorkspaceId: Guid): Boolean
procedure SynchronizeDataflows(WorkspaceId: Guid): Boolean
procedure SynchronizeDashboards(WorkspaceId: Guid): Boolean
procedure SynchronizeReports(WorkspaceId: Guid): Boolean

// Refresh Operations
procedure TriggerDatasetRefresh(WorkspaceId: Guid; DatasetId: Guid): Boolean
procedure TriggerDataflowRefresh(WorkspaceId: Guid; DataflowId: Guid): Boolean

// History Operations
procedure GetDatasetRefreshHistory(WorkspaceId: Guid; DatasetId: Guid): Boolean
procedure GetDataflowRefreshHistory(WorkspaceId: Guid; DataflowId: Guid): Boolean

// Backward Compatibility Methods
procedure SynchronizeReports(): Boolean
procedure SynchronizeReportsForWorkspace(WorkspaceId: Guid): Boolean
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

## 📝 Change Log

### Version 1.2.0 (Latest) - Architecture Modernization
- 🏗️ **Service-Oriented Architecture**: Complete migration from monolithic to service-oriented design
- 🔧 **Enhanced Error Handling**: Improved error detection with actionable user feedback
- 📦 **Specialized Managers**: Dedicated managers for each Power BI resource type
- 🎯 **Clean Orchestration**: New PowerBI API Orchestrator provides unified, clean interface
- 🔄 **Zero Breaking Changes**: Seamless migration maintaining all existing functionality
- 📈 **Better Maintainability**: Smaller, focused components easier to test and extend
- ✨ **Improved UX**: Enhanced success/error messaging with troubleshooting guidance
- 🏛️ **Modular Design**: Easy to add new Power BI resource types and operations

### Version 1.1.0 - Enhanced Operations
- ✅ **Enhanced Refresh History**: Complete refresh history tracking for datasets and dataflows
- ✅ **Improved User Interface**: Standardized actions with consistent grouping and naming
- ✅ **Bulk Operations**: Comprehensive bulk refresh capabilities (selected/all)
- ✅ **Advanced Filtering**: Enhanced filtering options in history pages
- ✅ **Error Analysis**: Detailed error information and troubleshooting capabilities
- ✅ **Bug Fixes**: Resolved GUID format errors and data population issues
- ✅ **Performance**: Optimized API calls and response processing

### Version 1.0.0 (Initial Release)
- ✅ **Core Functionality**: Basic Power BI resource synchronization
- ✅ **Authentication**: OAuth 2.0 client credentials flow
- ✅ **Setup Wizard**: Guided configuration experience
- ✅ **Basic Operations**: Individual refresh operations and monitoring

---

**Power BI Monitor v1.2.0** | Built with ❤️ for Business Central | Service-Oriented Architecture ✨