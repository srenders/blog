# API Performance Extension# API Performance Extension# API Performance Extension# API Performance Extension



Test and compare API performance with different database indexing strategies in Business Central.



## Table of ContentsTest and compare API performance with different database indexing strategies in Business Central.

- [What Is This?](#what-is-this)

- [Quick Start](#quick-start)

- [What's Included](#whats-included)

- [How to Use](#how-to-use)## Table of ContentsBusiness Central extension for testing and comparing API performance with different database indexing strategies.Business Central extension for testing and comparing API performance with different indexing strategies.

- [API Endpoints](#api-endpoints)

- [Testing Tips](#testing-tips)

- [Technical Details](#technical-details)

- [What Is This?](#what-is-this)

## What Is This?

- [Quick Start](#quick-start)

This extension lets you compare how different database keys and indexes affect API performance in Business Central. 

- [What's Included](#whats-included)## Overview## Overview

**The Setup:**

- 4 tables with identical fields- [How to Use](#how-to-use)

- Each table uses a different indexing strategy

- 12 API endpoints to test performance- [API Endpoints](#api-endpoints)

- Tools to generate test data

- [Testing Tips](#testing-tips)

**Why?** To see which indexing strategy works best for your specific queries.

- [Technical Details](#technical-details)This extension helps you test and compare how different key and covering index strategies affect API performance in Business Central. It includes 4 table variants with identical fields but different indexing approaches, along with 12 API endpoints for comprehensive testing.This extension provides tools to test and compare database key and covering index strategies in Business Central APIs. It includes 4 table variants with identical fields but different indexing approaches, allowing you to measure and compare performance.

## Quick Start



1. Install the extension

2. Search for **"API Performance Hub"**---

3. Click **"Populate ALL Table Variants"**

4. Enter a number (try 10,000 records)

5. Test the APIs with Postman or Power BI

6. Compare response times## What Is This?## Features## Features



That's it! 🎉



## What's IncludedThis extension lets you compare how different database keys and indexes affect API performance in Business Central. 



### 4 Table Variants



| Table | Strategy | Use Case |**The Setup:**### 4 Table Variants- **4 Table Variants** with different indexing strategies:

|-------|----------|----------|

| **Original** (91100) | Covering indexes + SumIndexFields | Best performance |- 4 tables with identical fields

| **No Covering** (91103) | Regular keys only | Standard approach |

| **Minimal** (91104) | Primary key only | Worst case |- Each table uses a different indexing strategy- **Original with Covering Indexes** (91100) - Optimized with covering indexes and SumIndexFields  - Original with Covering Indexes (91100)

| **Alternative** (91105) | Different covering strategy | Alternative optimization |

- 12 API endpoints to test performance

### 12 API Endpoints

- Tools to generate test data- **No Covering Indexes** (91103) - Regular keys only  - No Covering Indexes (91103)

Each table has 3 APIs:

- **Page API** - Standard OData access

- **Query API** - Query-based access

- **Aggregate API** - Pre-aggregated data**Why?** To see which indexing strategy works best for your specific queries.- **Minimal Keys** (91104) - Only primary key (worst-case scenario)  - Minimal Keys (91104)



### Pages



- **API Performance Hub** - Central dashboard---- **Alternative Covering Strategy** (91105) - Different covering approach  - Alternative Covering Strategy (91105)

- **4 List Pages** - One for each table (read-only, newest first)



## How to Use

## Quick Start

### Generate Test Data



**Option 1: All Tables at Once** (recommended)

1. Open "API Performance Hub"1. Install the extension### 12 API Endpoints- **12 API Endpoints** (3 per table variant):

2. Click "Populate ALL Table Variants"

3. Enter number of records2. Search for **"API Performance Hub"**



**Option 2: One Table at a Time**3. Click **"Populate ALL Table Variants"**Each table variant has 3 APIs:  - Page APIs for standard OData access

1. Open any list page

2. Actions → "Insert Test Data"4. Enter a number (try 10,000 records)

3. Enter number of records

5. Test the APIs with Postman or Power BI- **Page API** - Standard OData page-based access  - Query APIs for optimized queries

### Clean Up Data

6. Compare response times

- **Delete Test Data** - Removes records starting with "TEST-"

- **Delete All Data** - Removes everything (careful!)- **Query API** - Optimized query-based access  - Aggregate Query APIs for pre-aggregated data



## API EndpointsThat's it! 🎉



### Pattern- **Aggregate Query API** - Pre-aggregated data with SUM operations

```

https://[bc-url]/api/v2.0/companies([id])/[endpoint]---

```

- **Test Data Generation**:

### Examples

```## What's Included

/simpleTransactionAPI          # Original table - Page API

/simpleTransactionQuery        # Original table - Query API### Test Data Generation  - Generate test records for performance testing

/simpleTransNoCoversAPI        # No covering table - Page API

/simpleTransMinimalAPI         # Minimal keys table - Page API### 4 Table Variants

```

- Generate thousands of test records  - Populate all variants with identical data for fair comparison

### Test Query Example

```http| Table | Strategy | Use Case |

GET /simpleTransactionAPI?$filter=postingDate ge 2024-01-01

```|-------|----------|----------|- Populate all variants with identical data  - Bulk insert/delete operations



Run this same query against all 4 variants and compare times.| **Original** (91100) | Covering indexes + SumIndexFields | Best performance |



## Testing Tips| **No Covering** (91103) | Regular keys only | Standard approach |- Bulk insert and delete operations



### Do This ✅| **Minimal** (91104) | Primary key only | Worst case |

- Generate identical data in all tables

- Test with realistic volumes (10,000+ records)| **Alternative** (91105) | Different covering strategy | Alternative optimization |- Progress tracking for large datasets- **User Interface**:

- Run tests multiple times and average results

- Try different query patterns (filters, sorting, aggregates)



### Avoid This ❌### 12 API Endpoints  - API Performance Hub - central dashboard

- Testing with different data in each table

- Using tiny datasets (<1,000 records)

- Drawing conclusions from a single test

- Ignoring SQL execution plansEach table has 3 APIs:### User Interface  - List pages for each table variant (read-only, sorted descending)



### Sample Test Scenario- **Page API** - Standard OData access



1. **Generate Data:** 10,000 records in all tables- **Query API** - Query-based access- **API Performance Hub** - Central dashboard showing all variants  - Quick access to test data operations

2. **Test Query:** Filter by date range

3. **Measure:** Response time for each API- **Aggregate API** - Pre-aggregated data

4. **Compare:** Which index strategy is fastest?

5. **Analyze:** Check SQL execution plans- **List Pages** - One for each table variant (read-only, descending sort)



## Technical Details### Pages



### Object Ranges- **Quick Actions** - Easy access to test data operations## Quick Start

- Tables: 91100-91105

- Pages: 91100, 91115-91118- **API Performance Hub** - Central dashboard

- APIs: 91100-91114

- Codeunits: 91100-91106- **4 List Pages** - One for each table (read-only, newest first)



### Architecture

Built with SOLID principles:

- Interface-based design---## Quick Start1. **Install** the extension in your Business Central environment

- Factory pattern

- No code duplication

- Easy to extend

## How to Use2. **Open** the "API Performance Hub" page

### Requirements

- Business Central 26.0 or later



### Test Data### Generate Test Data1. **Install** the extension in Business Central3. **Generate Test Data**:

All test records have Document No. starting with "TEST-"



## Author

**Option 1: All Tables at Once** (recommended)2. Search for **"API Performance Hub"**   - Click "Populate ALL Table Variants"

**Steven Renders**  

Version: 1.0.0.01. Open "API Performance Hub"



---2. Click "Populate ALL Table Variants"3. Click **"Populate ALL Table Variants"**   - Enter number of records (e.g., 10,000)



**Need Help?** Check the comments in the AL code - they explain everything.3. Enter number of records


4. Enter number of records (e.g., 10000)4. **Test APIs** using your preferred tool (Postman, Power BI, etc.)

**Option 2: One Table at a Time**

1. Open any list page5. **Test your APIs** using Postman, Power BI, or any HTTP client5. **Compare Results** - measure response times across variants

2. Actions → "Insert Test Data"

3. Enter number of records6. **Compare response times** across the 4 endpoints



### Clean Up Data## API Endpoints



- **Delete Test Data** - Removes records starting with "TEST-"## API Endpoint Pattern

- **Delete All Data** - Removes everything (careful!)

All APIs follow this pattern:

---

``````

## API Endpoints

https://[environment]/api/v2.0/companies([companyId])/[endpoint]https://[environment]/api/v2.0/companies([companyId])/[endpoint]

### Pattern

`````````

https://[bc-url]/api/v2.0/companies([id])/[endpoint]

```



### Examples### Example Endpoints### Example Endpoints (Original Table)

```

/simpleTransactionAPI          # Original table - Page API```- Page API: `/simpleTransactionAPI`

/simpleTransactionQuery        # Original table - Query API

/simpleTransNoCoversAPI        # No covering table - Page API/simpleTransactionAPI          # Original - Page API- Query API: `/simpleTransactionQuery`

/simpleTransMinimalAPI         # Minimal keys table - Page API

```/simpleTransactionQuery        # Original - Query API- Aggregate API: `/simpleTransactionQueryAggr`



### Test Query Example/simpleTransactionQueryAggr    # Original - Aggregate API

```http

GET /simpleTransactionAPI?$filter=postingDate ge 2024-01-01Similar endpoints exist for all 4 table variants.

```

/simpleTransNoCoversAPI        # No Covering - Page API

Run this same query against all 4 variants and compare times.

/simpleTransMinimalAPI         # Minimal Keys - Page API## Architecture

---

/simpleTransAltCoverAPI        # Alt Covering - Page API

## Testing Tips

```The extension follows SOLID principles:

### Do This ✅

- Generate identical data in all tables- **Interface-based design** (`ITest Data Generator`)

- Test with realistic volumes (10,000+ records)

- Run tests multiple times and average results## Architecture- **Factory pattern** for creating test data generators

- Try different query patterns (filters, sorting, aggregates)

- **Shared base class** for common helper methods

### Avoid This ❌

- Testing with different data in each tableThe extension follows **SOLID principles** with a clean architecture:- **Separate implementations** for each table variant

- Using tiny datasets (<1,000 records)

- Drawing conclusions from a single test

- Ignoring SQL execution plans

- **Interface** (`ITest Data Generator`) - Defines the contractThis architecture eliminates code duplication and makes it easy to add new table variants.

### Sample Test Scenario

- **Factory Pattern** - Creates appropriate generators

1. **Generate Data:** 10,000 records in all tables

2. **Test Query:** Filter by date range- **Base Generator** - Shared helper methods (no duplication)## Object Ranges

3. **Measure:** Response time for each API

4. **Compare:** Which index strategy is fastest?- **4 Implementations** - One per table variant

5. **Analyze:** Check SQL execution plans

- Tables: 91100-91105

---

This eliminates code duplication and makes adding new variants easy.- Pages: 91100, 91115-91118

## Technical Details

- APIs: 91100-91114

### Object Ranges

- Tables: 91100-91105## Object Ranges- Codeunits: 91100-91106

- Pages: 91100, 91115-91118

- APIs: 91100-91114- Queries: 91100-91114

- Codeunits: 91100-91106

| Object Type | Range |

### Architecture

Built with SOLID principles:|-------------|-------|## Test Data

- Interface-based design

- Factory pattern| Tables | 91100-91105 |

- No code duplication

- Easy to extend| Pages | 91100, 91115-91118 |Test records have Document No. starting with "TEST-" for easy identification and cleanup.



### Requirements| APIs (Pages) | 91102, 91106-91108 |

- Business Central 26.0 or later

| APIs (Queries) | 91101, 91109-91111 |## Requirements

### Test Data

All test records have Document No. starting with "TEST-"| APIs (Aggregates) | 91100, 91112-91114 |



---| Codeunits | 91100-91106 |- Microsoft Dynamics 365 Business Central



## Author| Enum | 91100 |- Version 26.0 or later



**Steven Renders**  | Interface | ITestDataGenerator |

Version: 1.0.0.0

## Author

---

## Test Data

**Need Help?** Check the comments in the AL code - they explain everything.

Steven Renders

All test records have **Document No.** starting with **"TEST-"** for easy identification and cleanup.

---

### Operations Available

- **Insert Test Data** - Generate records for one tableFor questions or issues, refer to the AL source code comments.

- **Populate ALL Table Variants** - Generate identical data across all 4 tables

- **Delete Test Data** - Remove only TEST-* records- 🔄 **Data Cleanup** - Tools for managing test data lifecycle

- **Delete All Data** - Remove all records (with confirmation)- 📈 **Performance Metrics** - Track and analyze API performance over time



## Usage Tips## 🏗️ Architecture



1. **Start with small datasets** (1,000 records) to verify setup### Object Structure

2. **Use identical data** across variants for fair comparison

3. **Test different query patterns** - filters, sorting, aggregations```

4. **Measure response times** with your API testing toolAPI Performance Extension

5. **Check SQL execution plans** in BC database for deeper analysis├── Tables (4 variants for comparison)

6. **Compare covering vs non-covering** indexes with filter queries│   ├── Simple Transaction Entry (91100) - Original with covering

7. **Test SumIndexFields** performance with aggregate queries│   ├── Simple Trans No Covers (91103) - No covering indexes

│   ├── Simple Trans Minimal Keys (91104) - Minimal indexing

## Example Test Scenario│   └── Simple Trans Alt Covering (91105) - Alternative covering

├── Pages

```http│   ├── API Performance Hub (91118) - Central management page

# Test 1: Filter by date (should benefit from covering indexes)│   ├── Simple Transaction Entries (91100) - Original table page

GET /simpleTransactionAPI?$filter=postingDate ge 2024-01-01│   ├── Simple Trans No Covers List (91115) - No covering page

│   ├── Simple Trans Minimal List (91116) - Minimal keys page

# Test 2: Filter by customer and date (covering index helps)│   ├── Simple Trans Alt Cover List (91117) - Alt covering page

GET /simpleTransactionAPI?$filter=customerNo eq '10000' and postingDate ge 2024-01-01│   └── Number Input Dialog (91103) - Input dialog

├── APIs (Page, Query, and Aggregate for each table variant)

# Test 3: Aggregate by customer (SumIndexFields should help)│   ├── Original Table APIs

GET /simpleTransactionQueryAggr?$apply=groupby((customerNo),aggregate(amountLCY with sum as total))│   │   ├── Simple Transaction API (91102) - Page-based

```│   │   ├── Simple Transaction Query (91101) - Query-based

│   │   └── Simple Transaction Query Aggr (91100) - Aggregated

Run the same tests against all 4 variants and compare response times.│   ├── No Covering APIs (91106, 91109, 91112)

│   ├── Minimal Keys APIs (91107, 91110, 91113)

## Requirements│   └── Alt Covering APIs (91108, 91111, 91114)

├── Codeunits

- **Microsoft Dynamics 365 Business Central** version 26.0 or later│   └── Simple Transaction Test Data (91100) - Test data generation

- **AL Language Extension** for development│       ├── Individual table operations

- **API testing tool** (Postman, Insomnia, etc.) for performance testing│       └── Bulk operations for all tables

├── Enums

## Project Structure│   └── Simple Document Type (91100)

└── Documentation

```    ├── README.md - This file

src/    ├── KEY_INDEX_COMPARISON.md - Detailed comparison guide

├── APIs/          # 12 API endpoints (3 per table variant)    └── QUICK_REFERENCE.md - API endpoints and test queries

├── Codeunit/      # Test data generators (SOLID architecture)```

├── Interface/     # ITest Data Generator interface

├── Enum/          # Simple Document Type### Key Components

├── Page/          # List pages and hub

└── Table/         # 4 table variants with different indexes**Simple Transaction Entry Table**

```- Lightweight transaction data structure

- Optimized for high-volume operations

## Tips for Performance Testing- Includes customer reference, posting date, document information, and amounts



**Do:****API Implementations**

- ✅ Use identical data across all variants- Page API: Traditional Business Central page exposed as API

- ✅ Test with realistic data volumes- Query API: Direct query-based data access for improved performance

- ✅ Measure multiple runs and average results- Aggregated Query: Pre-aggregated data for analytical use cases

- ✅ Test different query patterns

- ✅ Check SQL execution plans**Test Data Generator**

- Efficient bulk data creation

**Don't:**- Realistic transaction patterns

- ❌ Compare without identical data- Configurable data volumes for testing different scenarios

- ❌ Test with trivial data volumes (<1000 records)

- ❌ Make conclusions from single runs## 📖 Usage

- ❌ Ignore caching effects (warm vs cold cache)

### Using the API Performance Hub (Recommended)

## Author

1. **Open API Performance Hub**

**Steven Renders**   - Search for "API Performance Hub" in Business Central

   - View record counts for all table variants at a glance

Extension Version: 1.0.0.0     - Access all management actions from one location

Business Central: 26.0.0.0+

2. **Populate All Tables at Once**

---   - Click "Populate ALL Table Variants"

   - Enter desired number of test records

For questions or issues, review the AL source code - it's well-commented and follows best practices.   - System generates identical data across all 4 variants

   - Monitor progress for each table

3. **Access Individual Tables**
   - Use navigation buttons to open specific table variants
   - View and manage data for each configuration separately

### Alternative: Individual Table Pages

Each table variant has its own page with dedicated actions:

1. **Simple Transaction Entries** (Original) - Default table with covering indexes
2. **Simple Trans No Covers List** - Table without covering indexes
3. **Simple Trans Minimal List** - Table with only primary key
4. **Simple Trans Alt Cover List** - Table with alternative covering strategy

### Creating Test Data

**Option A: Bulk Population (Recommended for Comparison Testing)**
- Open any table variant page
- Navigate → Bulk Operations → "Populate ALL Table Variants"
- Enter number of records
- All 4 tables populated with identical data

**Option B: Individual Table Population**
- Open specific table page
- Actions → "Insert Test Data"
- Enter number of records for that table only

### Managing Test Data

**Delete Test Records Only (TEST-* prefix)**
- Removes only records with Document No. starting with "TEST-"
- Preserves any other data

**Delete All Records**
- Removes all records from selected table(s)
- Warning: Cannot be undone

**Bulk Operations**
- Apply delete operations across all 4 table variants at once
- Available from API Performance Hub or Original table page

### Comparing Key and Index Performance

See **[KEY_INDEX_COMPARISON.md](KEY_INDEX_COMPARISON.md)** for detailed instructions on:

1. **Understanding Table Variants** - What makes each configuration different
2. **Testing Scenarios** - Specific API calls to test performance
3. **Expected Results** - Performance predictions for each scenario
4. **Analysis Tools** - How to measure and compare results
5. **Best Practices** - When to use covering indexes vs regular keys

### Quick Comparison Test

**Step 1:** Generate identical test data in all 4 table variants

**Step 2:** Run the same API query against each endpoint:
```http
# Original with covering indexes
GET /api/performance/performance/v1.0/simpleTransactionEntriesPages?$filter=postingDate ge 2024-01-01

# No covering indexes
GET /api/performance/performance/v1.0/simpleTransactionNoCovers?$filter=postingDate ge 2024-01-01

# Minimal keys only
GET /api/performance/performance/v1.0/simpleTransactionMinimal?$filter=postingDate ge 2024-01-01

# Alternative covering strategy
GET /api/performance/performance/v1.0/simpleTransactionAltCover?$filter=postingDate ge 2024-01-01
```

**Step 3:** Compare response times and SQL execution plans

**Step 4:** Document findings for your specific scenario

##  Project Structure

```
src/
├── APIs/
│   ├── SimpleTransactionAPI.Page.al             # Page-based API (Original)
│   ├── SimpleTransNoCoversAPI.Page.al           # Page API (No Covering)
│   ├── SimpleTransMinimalAPI.Page.al            # Page API (Minimal Keys)
│   ├── SimpleTransAltCoverAPI.Page.al           # Page API (Alt Covering)
│   ├── SimpleTransactionQuery.Query.al          # Query API (Original)
│   ├── SimpleTransNoCoversQuery.Query.al        # Query API (No Covering)
│   ├── SimpleTransMinimalQuery.Query.al         # Query API (Minimal Keys)
│   ├── SimpleTransAltCoverQuery.Query.al        # Query API (Alt Covering)
│   └── [4 Aggregate Query APIs]                 # Aggregated APIs for all variants
├── Codeunit/
│   ├── SimpleTransactionTestData.Codeunit.al    # Main facade (backward compatible)
│   ├── BaseTestDataGenerator.Codeunit.al        # Shared helper methods
│   ├── OriginalTableGenerator.Codeunit.al       # Original table implementation
│   ├── NoCoversTableGenerator.Codeunit.al       # No Covers implementation
│   ├── MinimalKeysTableGenerator.Codeunit.al    # Minimal Keys implementation
│   ├── AltCoverTableGenerator.Codeunit.al       # Alt Cover implementation
│   └── TestDataGeneratorFactory.Codeunit.al     # Factory pattern orchestrator
├── Interface/
│   └── ITestDataGenerator.Interface.al          # Test data generator contract
├── Enum/
│   └── SimpleDocumentType.Enum.al               # Document type enumeration
├── Page/
│   ├── NumberInputDialog.Page.al                # Input dialog for test data
│   ├── SimpleTransactionEntries.Page.al         # Main transaction list page
│   ├── SimpleTransNoCoversList.Page.al          # No Covers list page
│   ├── SimpleTransMinimalList.Page.al           # Minimal Keys list page
│   ├── SimpleTransAltCoverList.Page.al          # Alt Cover list page
│   └── APIPerformanceHub.Page.al                # Central dashboard
├── PowerBI Reports/
│   ├── performance Page API.pbix                # Page API analysis
│   ├── performance Query API.pbix               # Query API analysis
│   └── performance Query API Aggr.pbix          # Aggregated query analysis
└── Table/
    ├── SimpleTransactionEntry.Table.al          # Original table (with covering)
    ├── SimpleTransNoCovers.Table.al             # No covering indexes variant
    ├── SimpleTransMinimalKeys.Table.al          # Minimal keys variant
    └── SimpleTransAltCovering.Table.al          # Alternative covering variant
```

## 📚 Documentation

Comprehensive documentation is available:

- **[SOLID_REFACTORING.md](SOLID_REFACTORING.md)** - Detailed explanation of SOLID principles refactoring
- **[ARCHITECTURE_QUICK_REF.md](ARCHITECTURE_QUICK_REF.md)** - Quick reference for developers
- **[ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md)** - Visual architecture diagrams
- **[REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)** - Summary of refactoring changes
- **[KEY_INDEX_COMPARISON.md](KEY_INDEX_COMPARISON.md)** - Key and index performance testing guide
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - API endpoints and test queries
- **[PAGES_TESTDATA_GUIDE.md](PAGES_TESTDATA_GUIDE.md)** - Page and test data management guide

## 🏗️ SOLID Principles

This extension demonstrates **production-quality architecture** following SOLID principles:

### ✅ Single Responsibility Principle (SRP)
- Each codeunit has one clear responsibility
- Interface defines test data operations
- Base generator provides shared helpers
- Each implementation handles ONE specific table

### ✅ Open/Closed Principle (OCP)
- Open for extension (add new table variants easily)
- Closed for modification (no changes to existing generators)
- Factory pattern enables dynamic behavior

### ✅ Liskov Substitution Principle (LSP)
- Any implementation of `ITest Data Generator` is substitutable
- Predictable behavior across all implementations

### ✅ Interface Segregation Principle (ISP)
- Clean interface with only essential operations
- Clients only see methods they need

### ✅ Dependency Inversion Principle (DIP)
- Pages depend on abstractions (interface)
- Factory provides concrete implementations
- Loose coupling throughout

**Grade: A** (improved from C-) 🎉

See [SOLID_REFACTORING.md](SOLID_REFACTORING.md) for detailed analysis.

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