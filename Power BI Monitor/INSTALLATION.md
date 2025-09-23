# Installation Guide
## Power BI Monitor for Business Central

### Version: 1.0.0
### Date: September 21, 2025

---

## 📚 Table of Contents

- [Prerequisites Check](#prerequisites-check)
- [Pre-Installation Preparation](#pre-installation-preparation)
- [Azure AD Application Setup](#azure-ad-application-setup)
- [Extension Installation](#extension-installation)
- [Configuration Methods](#configuration-methods)
- [Post-Installation Verification](#post-installation-verification)
- [Common Installation Issues](#common-installation-issues)
- [Advanced Configuration](#advanced-configuration)

---

## ✅ Prerequisites Check

Before beginning the installation, verify you have the following:

### 🏢 Business Central Requirements
- [ ] **Business Central Online/On-Premises**: Version 26.0 or later
- [ ] **Administrative Access**: Ability to install extensions
- [ ] **Extension Management**: Access to Extension Management page
- [ ] **Internet Connectivity**: Outbound HTTPS connections allowed

### ☁️ Microsoft 365/Azure Requirements
- [ ] **Azure AD Tenant**: Administrative access required
- [ ] **Power BI License**: Power BI Pro license (minimum)
- [ ] **App Registration Rights**: Ability to register applications in Azure AD
- [ ] **Admin Consent Rights**: Ability to grant admin consent for API permissions

### 🔑 Permissions Required

#### Azure AD Permissions
- [ ] **Application Administrator** or **Global Administrator** role
- [ ] **Power BI Administrator** role (recommended)
- [ ] **Cloud Application Administrator** (minimum)

#### Business Central Permissions
- [ ] **Extension Management** permission set
- [ ] **Power BI** permission set (if available)
- [ ] **Setup and Configuration** access

### 📋 Information to Gather
Before starting, collect the following information:

| Information | Example | Where to Find |
|------------|---------|---------------|
| **Tenant ID** | `12345678-1234-1234-1234-123456789012` | Azure Portal → Azure AD → Overview |
| **Power BI Workspace IDs** | Various GUIDs | Power BI Portal → Workspace Settings |
| **Business Central Environment** | Production/Sandbox | BC Admin Center |

---

## 🛠️ Pre-Installation Preparation

### Step 1: Verify Power BI Environment

1. **Log into Power BI Portal**
   ```
   https://app.powerbi.com
   ```

2. **Verify Workspace Access**
   - Navigate to workspaces you want to integrate
   - Ensure you have **Admin** or **Contributor** access
   - Note workspace names and IDs (found in workspace settings)

3. **Check Power BI Admin Settings**
   ```
   Power BI Admin Portal → Tenant Settings → Developer Settings
   ```
   - Verify "Service principals can use Power BI APIs" is **Enabled**
   - Note any IP restrictions or conditional access policies

### Step 2: Prepare Business Central Environment

1. **Access Extension Management**
   ```
   Business Central → Apps → Extension Management
   ```

2. **Verify Installation Permissions**
   - Ensure you can see "Upload Extension" action
   - Check that no blocking policies are in place

3. **Backup Current Configuration** (if upgrading)
   ```
   Export current Power BI setup if exists
   Document custom configurations
   ```

### Step 3: Network Configuration

Ensure the following URLs are accessible from your Business Central environment:

| Service | URL | Purpose |
|---------|-----|---------|
| **Azure AD** | `https://login.microsoftonline.com` | Authentication |
| **Power BI API** | `https://api.powerbi.com` | API calls |
| **Graph API** | `https://graph.microsoft.com` | Azure AD operations |

---

## 🏗️ Azure AD Application Setup

### Step 1: Create Application Registration

1. **Navigate to Azure Portal**
   ```
   https://portal.azure.com
   ```

2. **Open Azure Active Directory**
   ```
   Azure Portal → Azure Active Directory → App registrations
   ```

3. **Create New Registration**
   ```
   Click "New registration"
   ```
   
   **Fill out the form:**
   ```
   Name: "Business Central Power BI Monitor"
   Supported account types: "Accounts in this organizational directory only"
   Redirect URI: Leave blank for now
   ```
   
   **Click "Register"**

4. **Record Application Details**
   After registration, note these values:
   ```
   Application (client) ID: [Copy this value]
   Directory (tenant) ID: [Copy this value]
   ```

   > **⚠️ Important**: Save these values securely - you'll need them for Business Central configuration.

### Step 2: Configure API Permissions

1. **Navigate to API Permissions**
   ```
   Your App → API permissions → Add a permission
   ```

2. **Add Power BI Service Permissions**
   ```
   Microsoft APIs → Power BI Service → Application permissions
   ```
   
   **Select the following permissions:**
   - [ ] `Dataset.Read.All` - Read dataset metadata
   - [ ] `Dataset.ReadWrite.All` - Manage dataset refreshes
   - [ ] `Dataflow.Read.All` - Read dataflow metadata  
   - [ ] `Dataflow.ReadWrite.All` - Manage dataflow refreshes
   - [ ] `Group.Read.All` - Access workspace information
   - [ ] `Workspace.Read.All` - Read workspace metadata

3. **Grant Admin Consent**
   ```
   Click "Grant admin consent for [Your Organization]"
   Confirm the consent
   ```

   > **⚠️ Critical**: Admin consent is required for the application to function.

### Step 3: Create Client Secret

1. **Navigate to Certificates & Secrets**
   ```
   Your App → Certificates & secrets → Client secrets
   ```

2. **Add New Client Secret**
   ```
   Click "New client secret"
   Description: "BC Power BI Monitor Secret"
   Expires: Choose appropriate duration (24 months recommended)
   Click "Add"
   ```

3. **Copy Secret Value**
   ```
   IMMEDIATELY copy the secret value
   ```
   
   > **⚠️ Critical**: The secret value is only shown once. Store it securely.

### Step 4: Configure Power BI Workspace Access

1. **Add Service Principal to Workspaces**
   
   For each workspace you want to integrate:
   ```
   Power BI Portal → Workspace → Settings → Access
   ```
   
   **Add the service principal:**
   ```
   Enter: [Your App Name] or [Application ID]
   Role: Contributor or Admin
   Apply
   ```

2. **Verify Access**
   ```
   Confirm the service principal appears in the workspace access list
   ```

---

## 📦 Extension Installation

### Method 1: Install from AppSource (Recommended)

1. **Access Business Central**
   ```
   Navigate to your Business Central environment
   ```

2. **Open Extension Marketplace**
   ```
   Apps → Extension Marketplace
   Search for "Power BI Monitor"
   ```

3. **Install Extension**
   ```
   Click on the extension
   Review permissions and dependencies
   Click "Install"
   Wait for installation to complete
   ```

### Method 2: Manual Installation (Development/Testing)

1. **Download Extension File**
   ```
   Obtain the .app file from your source
   ```

2. **Upload to Business Central**
   ```
   Apps → Extension Management → Upload Extension
   ```

3. **Select File and Install**
   ```
   Browse and select the .app file
   Click "Deploy"
   Select installation scope (Tenant/Global)
   Click "Install"
   ```

### Step 3: Verify Installation

1. **Check Extension Status**
   ```
   Apps → Extension Management
   Find "Power BI Monitor"
   Status should show "Installed"
   ```

2. **Verify New Pages Available**
   Check that these pages are accessible:
   - [ ] Power BI Setup
   - [ ] Power BI Workspaces  
   - [ ] Power BI Datasets
   - [ ] Power BI Role Center

3. **Check Assisted Setup**
   ```
   Assisted Setup → Look for "Power BI Monitor Setup"
   ```

---

## ⚙️ Configuration Methods

Choose one of the following configuration methods:

### Method 1: Guided Setup Wizard (Recommended for First-Time Users)

1. **Access Assisted Setup**
   ```
   Business Central → Assisted Setup
   Find "Power BI Monitor Setup"
   Click "Start Setup"
   ```

2. **Follow Wizard Steps**

   **Step 1: Welcome**
   - Review the overview
   - Click "Next"

   **Step 2: Azure Portal**
   - Follow link to create Azure AD app (if not done)
   - Return when app is created
   - Click "Next"

   **Step 3: Basic Configuration**
   ```
   Client ID: [Enter your Application ID]
   Tenant ID: [Enter your Directory ID]
   Authority URL: https://login.microsoftonline.com/
   Power BI API URL: https://api.powerbi.com/v1.0/myorg/
   ```

   **Step 4: Authentication**
   ```
   Client Secret: [Enter your client secret]
   ```
   > **Note**: Secret is encrypted automatically

   **Step 5: Connection Test**
   - Wizard will test the connection
   - Resolve any errors before proceeding
   - Click "Next" when test passes

   **Step 6: Initial Sync**
   - Choose whether to sync workspaces immediately
   - Click "Next"

   **Step 7: Complete**
   - Review configuration summary
   - Click "Finish"

### Method 2: Manual Setup (For Advanced Users)

1. **Navigate to Power BI Setup**
   ```
   Search for "Power BI Setup"
   Open the setup page
   ```

2. **Configure Authentication**
   ```
   General FastTab:
   - Client ID: [Your Application ID]
   - Client Secret: [Your Client Secret]
   - Tenant ID: [Your Directory ID]
   
   URLs FastTab:
   - Authority URL: https://login.microsoftonline.com/
   - Power BI API URL: https://api.powerbi.com/v1.0/myorg/
   ```

3. **Test Connection**
   ```
   Actions → Test Connection
   Verify "Connection successful" message
   ```

4. **Configure Auto-Sync (Optional)**
   ```
   Actions → Manage Auto Sync
   Enable: Yes/No
   Frequency: 30 minutes (default)
   ```

---

## ✅ Post-Installation Verification

### Step 1: Authentication Test

1. **Test API Connection**
   ```
   Power BI Setup → Actions → Test Connection
   Expected Result: "Connection successful"
   ```

2. **Check Token Acquisition**
   ```
   Look for successful authentication in the test results
   No error messages should appear
   ```

### Step 2: Initial Data Synchronization

1. **Sync Workspaces**
   ```
   Power BI Workspaces → Actions → Refresh All Workspaces
   Wait for operation to complete
   ```

2. **Verify Workspace Data**
   ```
   Check that your Power BI workspaces appear in the list
   Verify workspace names and IDs are correct
   ```

3. **Sync Datasets**
   ```
   Power BI Datasets → Actions → Refresh All Datasets
   Wait for operation to complete
   ```

4. **Verify Dataset Data**
   ```
   Check that datasets from your workspaces appear
   Verify dataset names and metadata
   ```

### Step 3: Functionality Test

1. **Test Dataset Refresh**
   ```
   Power BI Datasets → Select a dataset
   Actions → Refresh Selected Dataset
   Verify operation completes successfully
   ```

2. **Check Refresh History**
   ```
   Power BI Datasets → Select a dataset
   Actions → Get Refresh History
   Verify historical data is retrieved
   ```

3. **Test Navigation**
   ```
   Power BI Workspaces → Select workspace
   Actions → Open in Power BI
   Verify browser opens to correct workspace
   ```

### Step 4: Role Center Setup

1. **Access Power BI Role Center**
   ```
   Search for "Power BI Role Center"
   Open the role center
   ```

2. **Verify Dashboard Elements**
   - [ ] Workspace overview
   - [ ] Dataset status summary
   - [ ] Recent activities
   - [ ] Quick actions

3. **Test Role Center Actions**
   ```
   Use the quick action tiles to navigate
   Verify all links work correctly
   ```

---

## 🔧 Common Installation Issues

### Issue 1: Authentication Failures

**Symptoms:**
- "Authentication failed" error during setup
- Connection test fails
- "Unauthorized" API responses

**Troubleshooting Steps:**

1. **Verify Azure AD Configuration**
   ```
   Check Application ID is correct
   Verify Tenant ID matches your organization
   Confirm client secret hasn't expired
   ```

2. **Check API Permissions**
   ```
   Azure Portal → Your App → API Permissions
   Verify all required permissions are present
   Ensure admin consent has been granted (green checkmarks)
   ```

3. **Test Outside Business Central**
   ```
   Use Postman or similar tool to test Azure AD authentication
   URL: https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/token
   ```

4. **Common Fixes**
   ```
   Regenerate client secret if expired
   Re-grant admin consent for permissions
   Verify tenant ID format (with hyphens)
   Check for typos in configuration
   ```

### Issue 2: Permission Errors

**Symptoms:**
- "Forbidden" errors when accessing workspaces
- "Insufficient privileges" messages
- Empty workspace/dataset lists

**Troubleshooting Steps:**

1. **Check Power BI Workspace Access**
   ```
   Power BI Portal → Workspace → Settings → Access
   Verify service principal is listed
   Confirm role is Contributor or Admin
   ```

2. **Verify Power BI Admin Settings**
   ```
   Power BI Admin Portal → Tenant Settings
   Check "Service principals can use Power BI APIs"
   Review any security group restrictions
   ```

3. **Test with User Account**
   ```
   Temporarily test with your user credentials
   If works with user but not service principal, check workspace access
   ```

### Issue 3: Network Connectivity Issues

**Symptoms:**
- "Network error" during API calls
- Timeouts during synchronization
- "HTTP Send failed" errors

**Troubleshooting Steps:**

1. **Check Network Connectivity**
   ```
   Test access to required URLs:
   - https://login.microsoftonline.com
   - https://api.powerbi.com
   - https://graph.microsoft.com
   ```

2. **Verify Firewall Settings**
   ```
   Ensure outbound HTTPS (port 443) is allowed
   Check for corporate proxy settings
   Verify no SSL inspection interfering
   ```

3. **Test from Business Central Server**
   ```
   On-premises: Test connectivity from BC server directly
   Online: Contact Microsoft support if persistent
   ```

### Issue 4: Extension Installation Problems

**Symptoms:**
- Installation fails or hangs
- Extension shows as "Not Installed"
- Missing pages after installation

**Troubleshooting Steps:**

1. **Check System Requirements**
   ```
   Verify Business Central version compatibility
   Ensure sufficient system resources
   Check for conflicting extensions
   ```

2. **Clear Browser Cache**
   ```
   Clear browser cache and cookies
   Try in incognito/private browsing mode
   Test with different browser
   ```

3. **Reinstall Extension**
   ```
   Uninstall existing extension
   Clear any related data (if safe to do so)
   Reinstall extension
   ```

---

## 🎛️ Advanced Configuration

### Multi-Environment Setup

If you have multiple Business Central environments (Dev, Test, Production):

1. **Create Separate Azure AD Apps**
   ```
   Recommended: One app per environment
   Alternative: Single app with multiple environments
   ```

2. **Environment-Specific Configuration**
   ```
   Use environment-specific Power BI workspaces
   Configure separate client secrets for security
   Implement environment naming conventions
   ```

### Custom Authentication

For organizations with specific security requirements:

1. **Certificate-Based Authentication**
   ```
   Azure AD App → Certificates & secrets → Certificates
   Upload organization certificate
   Configure Business Central to use certificate authentication
   ```

2. **Conditional Access Integration**
   ```
   Configure Azure AD conditional access policies
   Test with service principal access
   Implement compliance requirements
   ```

### Performance Optimization

For large organizations with many workspaces/datasets:

1. **Batch Processing Configuration**
   ```
   Power BI Setup → Advanced Settings
   Configure batch size limits
   Set timeout values appropriately
   ```

2. **Scheduled Synchronization**
   ```
   Use job queue for large sync operations
   Configure off-peak hours for bulk operations
   Monitor performance metrics
   ```

### Integration with Other Systems

For integration with external systems:

1. **Event-Driven Updates**
   ```
   Subscribe to Power BI webhook events
   Implement custom event handlers
   Configure real-time synchronization
   ```

2. **Custom APIs**
   ```
   Extend with custom REST endpoints
   Implement additional Power BI functionality
   Create custom reporting solutions
   ```

---

## 📋 Installation Checklist

Use this checklist to track your installation progress:

### Pre-Installation
- [ ] Business Central version verified (26.0+)
- [ ] Azure AD administrative access confirmed
- [ ] Power BI Pro license verified
- [ ] Network connectivity tested
- [ ] Required information gathered

### Azure AD Setup
- [ ] Application registered in Azure AD
- [ ] API permissions configured and consented
- [ ] Client secret created and saved
- [ ] Service principal added to Power BI workspaces
- [ ] Power BI admin settings verified

### Extension Installation
- [ ] Extension installed successfully
- [ ] Installation status verified
- [ ] New pages accessible
- [ ] Assisted setup available

### Configuration
- [ ] Authentication configured (wizard or manual)
- [ ] Connection test passed
- [ ] Initial workspace sync completed
- [ ] Dataset sync completed
- [ ] Auto-sync configured (if desired)

### Verification
- [ ] Dataset refresh test successful
- [ ] Navigation to Power BI portal works
- [ ] Role center functional
- [ ] All expected data visible
- [ ] Error-free operation confirmed

### Documentation
- [ ] Configuration details documented
- [ ] User training completed
- [ ] Support procedures established
- [ ] Backup procedures implemented

---

## 📞 Support Resources

### Installation Support
- **Documentation**: This guide and README.md
- **Video Tutorials**: [Link to tutorials if available]
- **Community Forums**: [Link to community support]

### Technical Support
- **GitHub Issues**: Report technical problems
- **Email Support**: [Support email address]
- **Emergency Contact**: [Emergency support information]

### Training Resources
- **User Guide**: Complete user documentation
- **Admin Guide**: Administration procedures
- **Best Practices**: Recommended configurations

---

**Installation Guide Version**: 1.0.0  
**Last Updated**: September 21, 2025  
**Next Review**: October 21, 2025

---

> **Success Tip**: Take your time with the Azure AD setup - most installation issues stem from incorrect authentication configuration. When in doubt, double-check your permissions and admin consent status.