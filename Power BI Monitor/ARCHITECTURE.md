# Technical Architecture Documentation
## Power BI Monitor for Business Central

### Version: 1.0.0
### Date: September 21, 2025

---

## 📐 Architecture Overview

The Power BI Monitor extension follows a **modular, service-oriented architecture** that implements SOLID principles and separation of concerns. The design emphasizes maintainability, testability, and scalability.

### 🎯 Design Principles

#### 1. Single Responsibility Principle (SRP)
Each codeunit has a single, well-defined purpose:
- **Authentication**: Only handles OAuth operations
- **HTTP Client**: Only manages HTTP communications
- **JSON Processor**: Only handles JSON parsing
- **Dataset Manager**: Only manages dataset operations

#### 2. Open/Closed Principle (OCP)
- Extension points through events
- Interface-based design for future extensibility
- Pluggable authentication mechanisms

#### 3. Dependency Inversion Principle (DIP)
- High-level modules don't depend on low-level modules
- Dependencies flow toward abstractions
- Testable through dependency injection patterns

---

## 🏗️ Component Architecture

### Core Components Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INTERFACE LAYER                     │
├─────────────────┬─────────────────┬─────────────────┬──────────┤
│  Setup Wizard   │ Role Center     │ Management Pages│ Overview │
│  (90117)        │ (90116)         │ (90101-90105)   │ Pages    │
└─────────────────┴─────────────────┴─────────────────┴──────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                      ORCHESTRATION LAYER                        │
├─────────────────┬─────────────────┬─────────────────┬──────────┤
│ API Management  │ Auto Sync       │ Assisted Setup  │ Guided   │
│ (90110)         │ (90120)         │ (90140)         │ Exp Impl │
└─────────────────┴─────────────────┴─────────────────┴──────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                       SERVICE LAYER                             │
├─────────────────┬─────────────────┬─────────────────┬──────────┤
│ Authentication  │ HTTP Client     │ JSON Processor  │ Dataset  │
│ (90130)         │ (90131)         │ (90132)         │ Mgr(90133)│
└─────────────────┴─────────────────┴─────────────────┴──────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                               │
├─────────────────┬─────────────────┬─────────────────┬──────────┤
│ Setup Table     │ Workspace Table │ Dataset Table   │ Dataflow │
│ (90110)         │ (90111)         │ (90112)         │ Table    │
└─────────────────┴─────────────────┴─────────────────┴──────────┘
```

---

## 🔄 Data Flow Architecture

### Authentication Flow
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  User Request   │───▶│ Authentication  │───▶│   Azure AD      │
└─────────────────┘    │   Codeunit      │    │   OAuth 2.0     │
                       │    (90130)      │    └─────────────────┘
                       └─────────────────┘             │
                               │                       │
                               ▼                       ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │  Token Cache    │    │  Access Token   │
                       │  (50 minutes)   │◀───│   Response      │
                       └─────────────────┘    └─────────────────┘
```

### API Request Flow
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Business Logic  │───▶│  HTTP Client    │───▶│   Power BI      │
│   (Managers)    │    │   (90131)       │    │   REST API      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       ▼                       ▼
         │              ┌─────────────────┐    ┌─────────────────┐
         │              │ Request Builder │    │ HTTP Response   │
         │              │ & Auth Headers  │    │    (JSON)       │
         │              └─────────────────┘    └─────────────────┘
         │                                              │
         ▼                                              ▼
┌─────────────────┐                          ┌─────────────────┐
│ Business Logic  │◀─────────────────────────│ JSON Processor  │
│   Processing    │                          │    (90132)      │
└─────────────────┘                          └─────────────────┘
```

### Data Synchronization Flow
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Trigger       │───▶│ API Management  │───▶│ Power BI API    │
│ (User/Schedule) │    │    (90110)      │    │   Endpoints     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                               │                       │
                               ▼                       ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │ Service Layer   │    │   JSON Data     │
                       │ (HTTP + JSON)   │◀───│   Response      │
                       └─────────────────┘    └─────────────────┘
                               │
                               ▼
                       ┌─────────────────┐
                       │ Data Storage    │
                       │ (BC Tables)     │
                       └─────────────────┘
```

---

## 🧩 Component Details

### 1. Authentication Layer (90130)

#### Responsibilities
- OAuth 2.0 token acquisition and management
- Token caching and automatic refresh
- Configuration validation
- Secure credential handling

#### Key Patterns
- **Singleton Pattern**: Ensures single authentication instance
- **Strategy Pattern**: Pluggable authentication methods
- **Cache-Aside**: Token caching with TTL

#### Dependencies
- Power BI Setup table (configuration)
- System functions (HTTP, DateTime)

```al
Architecture Pattern: Singleton + Strategy
┌─────────────────────────────────────┐
│        Authentication Manager       │
├─────────────────────────────────────┤
│ + GetAuthToken(): Text              │
│ + RefreshToken(): Boolean           │
│ + ValidateConfiguration(): Boolean  │
│ - TokenCache: Dictionary            │
│ - TokenExpiry: DateTime             │
└─────────────────────────────────────┘
```

### 2. HTTP Client Layer (90131)

#### Responsibilities
- Standardized HTTP request/response handling
- Authentication header injection
- Error handling and retry logic
- URL construction and parameter management

#### Key Patterns
- **Template Method**: Standardized request processing
- **Decorator Pattern**: Authentication header injection
- **Chain of Responsibility**: Error handling pipeline

#### Dependencies
- Authentication codeunit (token injection)
- Power BI Setup (base URLs)

```al
Architecture Pattern: Template Method + Decorator
┌─────────────────────────────────────┐
│          HTTP Client Manager        │
├─────────────────────────────────────┤
│ + ExecuteGetRequest(): JsonObject   │
│ + ExecutePostRequest(): JsonObject  │
│ + BuildApiUrl(): Text               │
│ - AddAuthHeaders(): HttpHeaders     │
│ - HandleHttpError(): Boolean        │
└─────────────────────────────────────┘
```

### 3. JSON Processing Layer (90132)

#### Responsibilities
- Consistent JSON parsing across all endpoints
- Data transformation and validation
- Type-safe data extraction
- Error handling for malformed JSON

#### Key Patterns
- **Factory Pattern**: JSON object creation
- **Adapter Pattern**: JSON to BC record conversion
- **Null Object Pattern**: Safe handling of missing properties

#### Dependencies
- System JSON libraries
- Business Central record types

```al
Architecture Pattern: Factory + Adapter
┌─────────────────────────────────────┐
│        JSON Processor Manager       │
├─────────────────────────────────────┤
│ + ExtractWorkspaceInfo(): Boolean   │
│ + ExtractDatasetInfo(): Boolean     │
│ + ExtractReportInfo(): Boolean      │
│ + ParseRefreshHistory(): Boolean    │
│ - SafeGetJsonValue(): Variant       │
└─────────────────────────────────────┘
```

### 4. Dataset Management Layer (90133)

#### Responsibilities
- Dataset-specific business logic
- Refresh orchestration and monitoring
- Performance metrics calculation
- Batch operations

#### Key Patterns
- **Command Pattern**: Refresh operations
- **Observer Pattern**: Status monitoring
- **Batch Pattern**: Bulk operations

#### Dependencies
- HTTP Client (API calls)
- JSON Processor (response parsing)
- Dataset table (data persistence)

```al
Architecture Pattern: Command + Observer
┌─────────────────────────────────────┐
│       Dataset Manager Service       │
├─────────────────────────────────────┤
│ + SynchronizeDatasets(): Boolean    │
│ + TriggerDatasetRefresh(): Boolean  │
│ + GetRefreshHistory(): Boolean      │
│ + CalculateStatistics(): Boolean    │
│ - ProcessRefreshCommand(): Boolean  │
└─────────────────────────────────────┘
```

---

## 📊 Data Model Architecture

### Entity Relationship Diagram

```
┌─────────────────┐    1:N     ┌─────────────────┐
│ Power BI Setup  │────────────│Power BI Workspace│
│    (90110)      │            │     (90111)     │
└─────────────────┘            └─────────────────┘
                                        │ 1:N
                                        ▼
                               ┌─────────────────┐
                               │Power BI Dataset │
                               │     (90112)     │
                               └─────────────────┘
                                        │ 1:N
                                        ▼
                               ┌─────────────────┐
                               │Power BI Dataflow│
                               │     (90113)     │
                               └─────────────────┘
```

### Table Specifications

#### Power BI Setup (90110)
```al
Key Design Patterns: Configuration Repository
┌─────────────────────────────────────────────┐
│ Field Name         │ Type      │ Purpose    │
├─────────────────────────────────────────────┤
│ Client ID          │ Text[250] │ Azure App  │
│ Client Secret      │ Text[250] │ Encrypted  │
│ Tenant ID          │ Text[250] │ Azure AD   │
│ Authority URL      │ Text[250] │ OAuth      │
│ Power BI API URL   │ Text[250] │ Base API   │
│ Auto Sync Enabled  │ Boolean   │ Automation │
│ Sync Frequency     │ Integer   │ Minutes    │
└─────────────────────────────────────────────┘
```

#### Power BI Workspace (90111)
```al
Key Design Patterns: Aggregate Root
┌─────────────────────────────────────────────┐
│ Field Name         │ Type      │ Purpose    │
├─────────────────────────────────────────────┤
│ Workspace ID       │ Guid      │ Primary Key│
│ Name               │ Text[100] │ Display    │
│ Type               │ Text[50]  │ Category   │
│ State              │ Text[50]  │ Status     │
│ Is Read Only       │ Boolean   │ Access     │
│ Last Sync Date     │ DateTime  │ Tracking   │
│ Dataset Count      │ Integer   │ Metrics    │
└─────────────────────────────────────────────┘
```

#### Power BI Dataset (90112)
```al
Key Design Patterns: Entity with Metrics
┌─────────────────────────────────────────────┐
│ Field Name         │ Type      │ Purpose    │
├─────────────────────────────────────────────┤
│ Dataset ID         │ Guid      │ Primary Key│
│ Workspace ID       │ Guid      │ Foreign Key│
│ Name               │ Text[100] │ Display    │
│ Web URL            │ Text[250] │ Navigation │
│ Last Refresh Status│ Text[50]  │ Monitoring │
│ Last Refresh Date  │ DateTime  │ Tracking   │
│ Refresh Count      │ Integer   │ Statistics │
│ Avg Refresh Duration│ Duration │ Performance│
│ Success Rate       │ Decimal   │ Quality    │
└─────────────────────────────────────────────┘
```

---

## 🔐 Security Architecture

### Authentication Security Model

```
┌─────────────────────────────────────────────┐
│              Security Layers                │
├─────────────────────────────────────────────┤
│ 1. Azure AD Authentication                  │
│    - OAuth 2.0 Client Credentials Flow     │
│    - Service Principal Authentication       │
│    - Multi-tenant Support                  │
├─────────────────────────────────────────────┤
│ 2. Token Management                         │
│    - Secure Token Caching (50 min TTL)     │
│    - Automatic Token Refresh               │
│    - Encrypted Storage in BC               │
├─────────────────────────────────────────────┤
│ 3. API Security                             │
│    - HTTPS Only Communication              │
│    - Request/Response Validation           │
│    - Rate Limiting Compliance              │
├─────────────────────────────────────────────┤
│ 4. Data Protection                          │
│    - Client Secret Encryption              │
│    - No PII Storage                        │
│    - Audit Trail Logging                   │
└─────────────────────────────────────────────┘
```

### Permission Model

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Azure AD App   │───▶│  Power BI API   │───▶│ Workspace Access│
│  Permissions    │    │   Permissions   │    │   Control       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Admin Consent   │    │ Scope Validation│    │ Resource Access │
│   Required      │    │   Per Request   │    │   Enforcement   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## ⚡ Performance Architecture

### Caching Strategy

#### 1. Token Caching
- **TTL**: 50 minutes (10 minutes before Azure expiry)
- **Storage**: In-memory cache with fallback
- **Invalidation**: Time-based + manual refresh

#### 2. Data Caching
- **Workspace Data**: Cached until manual refresh
- **Dataset Metadata**: Refreshed on demand
- **Performance Metrics**: Calculated and cached

### API Rate Limiting Compliance

```
┌─────────────────────────────────────────────┐
│            Rate Limiting Strategy           │
├─────────────────────────────────────────────┤
│ 1. Request Batching                         │
│    - Group related API calls               │
│    - Reduce total request count            │
├─────────────────────────────────────────────┤
│ 2. Intelligent Retry                       │
│    - Exponential backoff                   │
│    - Respect Retry-After headers           │
├─────────────────────────────────────────────┤
│ 3. Token Reuse                              │
│    - 50-minute token caching               │
│    - Minimize authentication requests      │
├─────────────────────────────────────────────┤
│ 4. Async Operations                         │
│    - Non-blocking refresh operations       │
│    - Background synchronization            │
└─────────────────────────────────────────────┘
```

---

## 🔄 Extension Points

### Event Architecture

#### 1. Setup Events
```al
[IntegrationEvent(false, false)]
procedure OnAfterPowerBISetup()

[IntegrationEvent(false, false)]
procedure OnBeforeAuthentication(var IsHandled: Boolean)

[IntegrationEvent(false, false)]
procedure OnAfterSuccessfulConnection()
```

#### 2. Synchronization Events
```al
[IntegrationEvent(false, false)]
procedure OnBeforeWorkspaceSync(var WorkspaceRecord: Record "Power BI Workspace")

[IntegrationEvent(false, false)]
procedure OnAfterWorkspaceSync(var WorkspaceRecord: Record "Power BI Workspace")

[IntegrationEvent(false, false)]
procedure OnDatasetRefreshTriggered(WorkspaceId: Guid; DatasetId: Guid)
```

#### 3. Error Handling Events
```al
[IntegrationEvent(false, false)]
procedure OnApiError(ErrorCode: Integer; ErrorMessage: Text; var IsHandled: Boolean)

[IntegrationEvent(false, false)]
procedure OnAuthenticationFailure(var RetryAllowed: Boolean)
```

### Extensibility Patterns

#### 1. Strategy Pattern Implementation
```al
// Interface for custom authentication methods
interface IPowerBIAuthenticationStrategy
{
    procedure GetAuthToken(): Text;
    procedure ValidateConfiguration(): Boolean;
}
```

#### 2. Plugin Architecture
```al
// Custom dataset managers
interface IPowerBIDatasetPlugin
{
    procedure ProcessCustomDataset(var DatasetRecord: Record "Power BI Dataset"): Boolean;
    procedure GetSupportedDatasetTypes(): List of [Text];
}
```

---

## 🧪 Testing Architecture

### Test Patterns

#### 1. Unit Testing Structure
```
Tests/
├── Authentication/
│   ├── PowerBIAuthenticationTest.Codeunit.al
│   └── MockAuthenticationProvider.Codeunit.al
├── HttpClient/
│   ├── PowerBIHttpClientTest.Codeunit.al
│   └── MockHttpClient.Codeunit.al
├── JsonProcessor/
│   ├── PowerBIJsonProcessorTest.Codeunit.al
│   └── SampleJsonResponses.Codeunit.al
└── Integration/
    ├── EndToEndTests.Codeunit.al
    └── MockPowerBIService.Codeunit.al
```

#### 2. Test Doubles Strategy
- **Mock Objects**: For external dependencies (HTTP, Azure AD)
- **Stub Objects**: For predictable responses
- **Fake Objects**: For in-memory test databases

#### 3. Test Data Management
```al
// Test data builder pattern
codeunit TestDataBuilder
{
    procedure CreateTestWorkspace(): Record "Power BI Workspace"
    procedure CreateTestDataset(): Record "Power BI Dataset"
    procedure CreateMockApiResponse(): JsonObject
}
```

---

## 📈 Monitoring & Observability

### Logging Architecture

#### 1. Structured Logging
```al
procedure LogApiCall(OperationType: Text; Endpoint: Text; Duration: Duration; Success: Boolean)
procedure LogAuthenticationEvent(EventType: Text; Success: Boolean; ErrorMessage: Text)
procedure LogSyncOperation(ResourceType: Text; Count: Integer; Duration: Duration)
```

#### 2. Performance Metrics
- API call duration tracking
- Success/failure rates
- Authentication performance
- Sync operation statistics

#### 3. Health Monitoring
```al
procedure PerformHealthCheck(): Boolean
procedure GetSystemStatus(): JsonObject
procedure ValidateConnectivity(): Boolean
```

---

## 🚀 Deployment Architecture

### Environment Strategy

#### 1. Development Environment
- Sandbox tenant with test Power BI workspace
- Mock services for unit testing
- Development certificates

#### 2. Staging Environment
- Production-like setup
- Integration testing with real Power BI
- Performance validation

#### 3. Production Environment
- Production Power BI tenant
- Monitoring and alerting
- Backup and recovery procedures

### Configuration Management

#### 1. Environment-Specific Settings
```al
procedure GetEnvironmentConfig(): Record "Power BI Setup"
procedure ValidateEnvironmentSettings(): Boolean
procedure MigrateConfiguration(FromVersion: Version; ToVersion: Version): Boolean
```

#### 2. Feature Flags
```al
enum PowerBIFeatureFlags
{
    AutoSync,
    AdvancedMetrics,
    BulkOperations,
    ExperimentalFeatures
}
```

---

## 🔧 Maintenance Architecture

### Update Strategy

#### 1. Backward Compatibility
- Versioned API interfaces
- Migration procedures for data structure changes
- Graceful degradation for missing features

#### 2. Hot Fixes
```al
procedure ApplyHotFix(FixId: Code[20]): Boolean
procedure ValidateHotFix(FixId: Code[20]): Boolean
procedure RollbackHotFix(FixId: Code[20]): Boolean
```

#### 3. Database Migrations
```al
codeunit DataMigrationManager
{
    procedure MigrateToVersion(TargetVersion: Version): Boolean
    procedure ValidateMigration(): Boolean
    procedure CreateBackup(): Boolean
}
```

---

## 📋 Quality Attributes

### Scalability
- **Horizontal**: Multiple workspace support
- **Vertical**: Large dataset handling
- **Performance**: Optimized API usage

### Reliability
- **Fault Tolerance**: Retry mechanisms
- **Error Recovery**: Graceful degradation
- **Data Consistency**: Transaction boundaries

### Security
- **Authentication**: OAuth 2.0 compliance
- **Authorization**: Principle of least privilege
- **Data Protection**: Encryption at rest and in transit

### Maintainability
- **Modularity**: SOLID principles
- **Documentation**: Comprehensive inline docs
- **Testing**: High test coverage

### Usability
- **Setup Experience**: Guided wizard
- **Error Messages**: Clear, actionable feedback
- **Documentation**: User-friendly guides

---

## 🎯 Future Architecture Considerations

### Planned Enhancements

#### 1. Multi-Tenant Support
```al
// Tenant-aware configuration
table "Power BI Tenant Config"
{
    field(1; "Tenant ID"; Text[250]) { }
    field(2; "Configuration"; JsonObject) { }
}
```

#### 2. Advanced Analytics
```al
// Embedded analytics engine
codeunit PowerBIAnalyticsEngine
{
    procedure GenerateUsageReport(): Report
    procedure PredictRefreshFailures(): List of [Guid]
    procedure OptimizeRefreshSchedule(): JsonObject
}
```

#### 3. Real-time Synchronization
```al
// Webhook-based updates
codeunit PowerBIWebhookHandler
{
    procedure ProcessWebhookNotification(Payload: JsonObject): Boolean
    procedure RegisterWebhookEndpoint(): Text
}
```

---

**Document Version**: 1.0.0  
**Last Updated**: September 21, 2025  
**Next Review**: October 21, 2025