# API Performance Extension for Microsoft Dynamics 365 Business Central

A comprehensive Business Central extension designed to demonstrate and compare API performance between different data access methods (Pages vs Queries) and provide tools for performance testing and analysis.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This extension provides a practical framework for testing and comparing API performance in Business Central, specifically focusing on:

- **Page-based APIs** vs **Query-based APIs**
- **Performance measurement** and analysis tools
- **Test data generation** capabilities
- **Power BI integration** for performance visualization
- **Real-world simulation** of transaction data

Perfect for developers, consultants, and architects who need to understand and optimize API performance in Business Central environments.

## ✨ Features

### Core Functionality
- ✅ **Simple Transaction Management** - Lightweight transaction entry system
- ✅ **Multiple API Types** - Page API, Query API, and Aggregated Query API
- ✅ **Test Data Generation** - Automated creation of test records for performance testing
- ✅ **Performance Monitoring** - Built-in tools for measuring API response times
- ✅ **Power BI Integration** - Pre-built reports for performance analysis

### API Endpoints
- 🔗 **Page API** - Traditional page-based data access
- 🔗 **Query API** - Optimized query-based data retrieval
- 🔗 **Aggregated Query API** - Pre-aggregated data for analytical scenarios

### Data Management
- 📊 **Bulk Data Creation** - Generate thousands of test records efficiently
- 🔄 **Data Cleanup** - Tools for managing test data lifecycle
- 📈 **Performance Metrics** - Track and analyze API performance over time

## 🏗️ Architecture

### Object Structure

```
API Performance Extension
├── Tables
│   └── Simple Transaction Entry (91100)
├── Pages
│   ├── Simple Transaction Entries (91101)
│   └── Number Input Dialog (91103)
├── APIs
│   ├── Simple Transaction API (91102) - Page-based
│   ├── Simple Transaction Query (91101) - Query-based
│   └── Simple Transaction Query Aggr (91104) - Aggregated
├── Codeunits
│   └── Simple Transaction Test Data (91100)
├── Enums
│   └── Simple Document Type (91100)
└── Power BI Reports
    ├── performance Page API.pbix
    ├── performance Query API.pbix
    └── performance Query API Aggr.pbix
```

### Key Components

**Simple Transaction Entry Table**
- Lightweight transaction data structure
- Optimized for high-volume operations
- Includes customer reference, posting date, document information, and amounts

**API Implementations**
- Page API: Traditional Business Central page exposed as API
- Query API: Direct query-based data access for improved performance
- Aggregated Query: Pre-aggregated data for analytical use cases

**Test Data Generator**
- Efficient bulk data creation
- Realistic transaction patterns
- Configurable data volumes for testing different scenarios

##  Usage

### Creating Test Data

1. **Open Simple Transaction Entries page**
   - Search for "Simple Transaction Entries"
   - Use the "Generate Test Data" action

2. **Specify Record Count**
   - Enter desired number of test records
   - System will generate realistic transaction data

3. **Monitor Progress**
   - Progress dialog shows creation status
   - Large datasets (>1000 records) display progress indicator

##  Project Structure

```
src/
├── APIs/
│   ├── SimpleTransactionAPI.Page.al          # Page-based API
│   ├── SimpleTransactionQuery.Query.al       # Query-based API
│   └── SimpleTransactionQuery Aggr.query.al  # Aggregated Query API
├── Codeunit/
│   └── SimpleTransactionTestData.Codeunit.al # Test data generation
├── Enum/
│   └── SimpleDocumentType.Enum.al            # Document type enumeration
├── Page/
│   ├── NumberInputDialog.Page.al             # Input dialog for test data
│   └── SimpleTransactionEntries.Page.al      # Main transaction list page
├── PowerBI Reports/
│   ├── performance Page API.pbix             # Page API analysis
│   ├── performance Query API.pbix            # Query API analysis
│   └── performance Query API Aggr.pbix       # Aggregated query analysis
└── Table/
    └── SimpleTransactionEntry.Table.al       # Core transaction table
```

## 🤝 Contributing

### Development Setup

1. **Clone the repository**
2. **Open in VS Code** with AL Language extension
3. **Configure launch.json** with your Business Central environment
4. **Download symbols** for your BC version

### Code Standards

- Follow Microsoft AL coding guidelines
- Include comprehensive XML documentation
- Implement proper error handling
- Write unit tests for custom logic

### Submitting Changes

1. **Create feature branch** from main
2. **Implement changes** with appropriate tests
3. **Update documentation** as needed
4. **Submit pull request** with detailed description

## 📋 Requirements

### Minimum Requirements
- Business Central 2024 Release Wave 1 (Version 24.0)
- AL Language Extension for VS Code
- PowerShell 5.1 or later

### Recommended Requirements
- Business Central 2024 Release Wave 2 (Version 25.0) or later
- Visual Studio Code with AL Language Extension
- Power BI Desktop (for performance analysis)
- Postman or similar API testing tool

##  License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For questions, issues, or contributions:

- **Author**: Steven Renders
- **Extension Version**: 1.0.0.0
- **Business Central Compatibility**: 26.0.0.0+

---

*This extension is designed for educational and performance testing purposes. Use in production environments should be carefully evaluated based on your specific requirements and data volumes.*