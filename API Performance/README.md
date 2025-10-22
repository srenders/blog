# API Performance Extension# API Performance Extension# API Performance Extension# API Performance Extension# API Performance Extension# API Performance Extension# API Performance Extension



Test and compare API READ performance with different database indexing strategies in Business Central.



## Table of ContentsTest and compare API READ performance with different database indexing strategies in Business Central.



- [What Is This?](#what-is-this)

- [Quick Start](#quick-start)

- [What's Included](#whats-included)## Table of ContentsTest and compare API performance with different database indexing strategies in Business Central.

- [How to Use](#how-to-use)

- [API Endpoints](#api-endpoints)

- [Testing Tips](#testing-tips)

- [Technical Details](#technical-details)- [What Is This?](#what-is-this)



## What Is This?- [Quick Start](#quick-start)



This extension lets you compare how different database keys and indexes affect API READ performance in Business Central - **optimized for Power BI scenarios**.- [What's Included](#whats-included)## Table of ContentsTest and compare API performance with different database indexing strategies in Business Central.



**The Setup:**- [How to Use](#how-to-use)

- 4 tables with identical fields

- Each table uses a different indexing strategy- [API Endpoints](#api-endpoints)

- 12 API endpoints to test READ performance

- Tools to generate test data- [Testing Tips](#testing-tips)

- **Built-in AL READ performance testing** designed for Power BI full-load scenarios

- [Technical Details](#technical-details)- [What Is This?](#what-is-this)

**Why?** Power BI typically loads ALL records from APIs. This extension helps you see which indexing strategy delivers the fastest performance when loading complete datasets.



## Quick Start

## What Is This?- [Quick Start](#quick-start)

1. Install the extension

2. Search for **"API Performance Hub"**

3. Click **"Populate ALL Table Variants"**

4. Enter a number (try 10,000 records)This extension lets you compare how different database keys and indexes affect API READ performance in Business Central. - [What's Included](#whats-included)## Table of ContentsTest and compare API performance with different database indexing strategies in Business Central.

5. Click **"Quick Read Performance Test"** to test reading ALL records

6. Or test the APIs with Power BI

7. Compare response times

**The Setup:**- [How to Use](#how-to-use)

That's it! 🎉

- 4 tables with identical fields

## What's Included

- Each table uses a different indexing strategy- [API Endpoints](#api-endpoints)- [What Is This?](#what-is-this)

### 4 Table Variants

- 12 API endpoints to test READ performance

| Table | Strategy | Use Case |

|-------|----------|----------|- Tools to generate test data- [Testing Tips](#testing-tips)

| **Original** (91100) | Covering indexes + SumIndexFields | Best performance |

| **No Covering** (91103) | Regular keys only | Standard approach |- **Built-in AL READ performance testing** to compare APIs without external tools

| **Minimal** (91104) | Primary key only | Worst case |

| **Alternative** (91105) | Different covering strategy | Alternative optimization |- [Technical Details](#technical-details)- [Quick Start](#quick-start)



### 12 API Endpoints**Why?** To see which indexing strategy works best for your specific READ queries.



Each table has 3 APIs:

- **Page API** - Standard OData READ access

- **Query API** - Query-based READ access## Quick Start

- **Aggregate API** - Pre-aggregated READ data

## What Is This?- [What's Included](#whats-included)

### Pages

1. Install the extension

- **API Performance Hub** - Central dashboard with built-in READ performance tests

- **4 List Pages** - One for each table (read-only, newest first)2. Search for **"API Performance Hub"**



### Built-in READ Performance Testing3. Click **"Populate ALL Table Variants"**



Run AL-based READ performance tests directly from the API Performance Hub - **optimized for Power BI scenarios**:4. Enter a number (try 10,000 records)This extension lets you compare how different database keys and indexes affect API performance in Business Central. - [How to Use](#how-to-use)## Table of ContentsBusiness Central extension for testing and comparing API performance with different database indexing strategies.Business Central extension for testing and comparing API performance with different indexing strategies.

- **Quick Read Performance Test** - Reads ALL records from Original vs No Covering tables

- **Filtered Read Test** - Reads ALL matching records (last 6 months filter)5. Click **"Quick Read Performance Test"** to run built-in READ tests

- **Aggregate Read Test** - Tests SUM operations on ALL records (SumIndexFields vs manual)

- **Run All Read Performance Tests** - Comprehensive READ testing of ALL records in all variants6. Or test the APIs with Postman or Power BI



**All tests are READ-ONLY operations** - they measure how fast ALL data can be retrieved through:7. Compare response times

- **Page APIs** (using record tables directly - simulates Page API endpoint)

- **Query APIs** (using query objects - simulates Query API endpoint)**The Setup:**- [API Endpoints](#api-endpoints)



**Power BI Focus**: Tests simulate Power BI's typical behavior of loading complete datasets, not just small samples. This gives you realistic performance metrics for your actual Power BI reports.That's it! 🎉



## How to Use- 4 tables with identical fields



### Generate Test Data## What's Included



**Option 1: All Tables at Once** (recommended)- Each table uses a different indexing strategy- [Testing Tips](#testing-tips)

1. Open "API Performance Hub"

2. Click "Populate ALL Table Variants"### 4 Table Variants

3. Enter number of records (10,000+ recommended for realistic Power BI testing)

- 12 API endpoints to test performance

**Option 2: One Table at a Time**

1. Open any list page| Table | Strategy | Use Case |

2. Actions → "Insert Test Data"

3. Enter number of records|-------|----------|----------|- Tools to generate test data- [Technical Details](#technical-details)



### Run Built-in READ Performance Tests| **Original** (91100) | Covering indexes + SumIndexFields | Best performance |



1. Open "API Performance Hub"| **No Covering** (91103) | Regular keys only | Standard approach |- **Built-in AL performance testing** to compare APIs without external tools

2. Navigate to **Performance Tests (AL Code)** group

3. Click one of the READ test actions:| **Minimal** (91104) | Primary key only | Worst case |

   - **Quick Read Performance Test** - Reads ALL records from 2 variants (fast comparison)

   - **Filtered Read Test** - Reads ALL matching records with date filter (Power BI scenario)| **Alternative** (91105) | Different covering strategy | Alternative optimization |- [What Is This?](#what-is-this)

   - **Aggregate Read Test** - SUM ALL records (CalcSums vs manual)

   - **Run All Read Performance Tests** - Complete READ benchmark (ALL records, all 4 variants)

4. View results in a message dialog showing READ times in milliseconds

### 12 API Endpoints**Why?** To see which indexing strategy works best for your specific queries.

**What the tests measure:**

- How long it takes to READ ALL records from each table variant

- Page API READ speed (via record table) vs Query API READ speed (via query object)

- Impact of covering indexes on full-table READ operationsEach table has 3 APIs:## What Is This?

- Impact of SumIndexFields on aggregate READ operations

- **Real-world Power BI performance** - simulates loading complete datasets- **Page API** - Standard OData READ access



### Test with Power BI (Recommended)- **Query API** - Query-based READ access## Quick Start



Connect Power BI to the API endpoints and measure actual load times:- **Aggregate API** - Pre-aggregated READ data

```

https://[environment]/api/performance/performance/v1.0/simpleTransactionEntriesPages- [Quick Start](#quick-start)

https://[environment]/api/performance/performance/v1.0/simpleTransactionEntryQuerys

```### Pages



Compare Power BI refresh times across all 4 table variants.1. Install the extension



### Clean Up Data- **API Performance Hub** - Central dashboard with built-in READ performance tests



- **Delete Test Data** - Removes records starting with "TEST-"- **4 List Pages** - One for each table (read-only, newest first)2. Search for **"API Performance Hub"**This extension lets you compare how different database keys and indexes affect API performance in Business Central. 

- **Delete All Data** - Removes everything (careful!)



## API Endpoints

### Built-in READ Performance Testing3. Click **"Populate ALL Table Variants"**

### Pattern

```

https://[bc-url]/api/v2.0/companies([id])/[endpoint]

```Run AL-based READ performance tests directly from the API Performance Hub:4. Enter a number (try 10,000 records)- [What's Included](#whats-included)## Overview## Overview



### Examples- **Quick Read Performance Test** - Reads first 100 records from each variant

```

/simpleTransactionAPI          # Original table - Page API (READ)- **Filtered Read Test** - Tests filtered READ queries (last 6 months)5. Click **"Quick Performance Test"** to run built-in tests

/simpleTransactionQuery        # Original table - Query API (READ)

/simpleTransNoCoversAPI        # No covering table - Page API (READ)- **Aggregate Read Test** - Tests SUM READ operations with SumIndexFields vs manual

/simpleTransMinimalAPI         # Minimal keys table - Page API (READ)

```- **Run All Read Performance Tests** - Comprehensive READ testing of all variants6. Or test the APIs with Postman or Power BI**The Setup:**



### Power BI Test Query Example

```http

GET /simpleTransactionAPI**All tests are READ-ONLY operations** - they measure how fast data can be retrieved through:7. Compare response times

GET /simpleTransactionQuery

```- **Page APIs** (using record tables directly - simulates Page API endpoint)



Run these queries in Power BI against all 4 variants and compare refresh times.- **Query APIs** (using query objects - simulates Query API endpoint)- 4 tables with identical fields- [How to Use](#how-to-use)



## Testing Tips



### Do This ✅No data is inserted, updated, or deleted during performance testing.That's it! 🎉



- Generate identical data in all tables (10,000+ records)

- Test READ operations with realistic volumes that match your production

- Run READ tests multiple times and average results## How to Use- Each table uses a different indexing strategy

- Use built-in tests to simulate Power BI loading ALL records

- Test with actual Power BI reports for real-world validation

- Try different READ query patterns (filters, sorting, aggregates)

### Generate Test Data## What's Included

### Avoid This ❌



- Testing with different data in each table

- Using tiny datasets (<10,000 records) - won't show realistic differences**Option 1: All Tables at Once** (recommended)- 12 API endpoints to test performance- [API Endpoints](#api-endpoints)

- Drawing conclusions from a single READ test

- Testing with small subsets when Power BI loads ALL records1. Open "API Performance Hub"

- Ignoring SQL execution plans

2. Click "Populate ALL Table Variants"### 4 Table Variants

### Sample Test Scenario (Power BI Focused)

3. Enter number of records

1. **Generate Data:** 50,000 records in all tables (realistic volume)

2. **Run Built-in READ Tests:** Click "Run All Read Performance Tests" - reads ALL records- Tools to generate test data

3. **Review Results:** Check which table variant has fastest READ times for complete datasets

4. **Test in Power BI:** Create identical reports using each API endpoint**Option 2: One Table at a Time**

5. **Compare Refresh Times:** Measure Power BI refresh performance

6. **Analyze:** Check SQL execution plans for deeper READ insights1. Open any list page| Table | Strategy | Use Case |



## Technical Details2. Actions → "Insert Test Data"



### Object Ranges3. Enter number of records|-------|----------|----------|- [Testing Tips](#testing-tips)



- Tables: 91100-91105

- Pages: 91100, 91115-91118

- APIs: 91100-91114### Run Built-in READ Performance Tests| **Original** (91100) | Covering indexes + SumIndexFields | Best performance |

- Codeunits: 91100-91107



### Architecture

1. Open "API Performance Hub"| **No Covering** (91103) | Regular keys only | Standard approach |**Why?** To see which indexing strategy works best for your specific queries.

Built with SOLID principles:

- Interface-based design2. Navigate to **Performance Tests (AL Code)** group

- Factory pattern

- No code duplication3. Click one of the READ test actions:| **Minimal** (91104) | Primary key only | Worst case |

- Easy to extend

   - **Quick Read Performance Test** - Fast comparison (reads 100 records)

The **API Performance Tester** codeunit (91107) provides built-in READ performance testing using:

- `CurrentDateTime` for precise timing measurements   - **Filtered Read Test** - Real-world filtering scenario (reads with date filter)| **Alternative** (91105) | Different covering strategy | Alternative optimization |- [Technical Details](#technical-details)This extension helps you test and compare how different key and covering index strategies affect API performance in Business Central. It includes 4 table variants with identical fields but different indexing approaches, along with 12 API endpoints for comprehensive testing.This extension provides tools to test and compare database key and covering index strategies in Business Central APIs. It includes 4 table variants with identical fields but different indexing approaches, allowing you to measure and compare performance.

- `Duration` data type for calculating elapsed READ time

- Comparison of Page API READ speed vs Query API READ speed   - **Aggregate Read Test** - SUM operations comparison (CalcSums vs manual)

- Testing all 4 table variants with identical READ operations

- **Reads ALL records** (not limited subsets) to simulate Power BI behavior   - **Run All Read Performance Tests** - Complete READ benchmark (all variants)

- **All tests are READ-ONLY** - no insert, update, or delete operations

4. View results in a message dialog showing READ times in milliseconds

### Requirements

### 12 API Endpoints## Quick Start

- Business Central 26.0 or later

**What the tests measure:**

### Test Data

- How long it takes to READ records from each table variant

All test records have Document No. starting with "TEST-"

- Page API READ speed (via record table) vs Query API READ speed (via query object)

## Author

- Impact of covering indexes on READ operationsEach table has 3 APIs:

**Steven Renders**  

Version: 1.0.0.0- Impact of SumIndexFields on aggregate READ operations



---- **Page API** - Standard OData access



**Need Help?** Check the comments in the AL code - they explain everything.### Test with External Tools (Optional)


- **Query API** - Query-based access1. Install the extension

You can also test READ performance using Postman, Power BI, or other HTTP clients:

```http- **Aggregate API** - Pre-aggregated data

GET https://[environment]/api/v2.0/companies([id])/simpleTransactionAPI

```2. Search for **"API Performance Hub"**---



### Clean Up Data### Pages



- **Delete Test Data** - Removes records starting with "TEST-"3. Click **"Populate ALL Table Variants"**

- **Delete All Data** - Removes everything (careful!)

- **API Performance Hub** - Central dashboard with built-in performance tests

## API Endpoints

- **4 List Pages** - One for each table (read-only, newest first)4. Enter a number (try 10,000 records)

### Pattern

```

https://[bc-url]/api/v2.0/companies([id])/[endpoint]

```### Built-in Performance Testing5. Test the APIs with Postman or Power BI



### Examples

```

/simpleTransactionAPI          # Original table - Page API (READ)Run AL-based performance tests directly from the API Performance Hub:6. Compare response times## What Is This?## Features## Features

/simpleTransactionQuery        # Original table - Query API (READ)

/simpleTransNoCoversAPI        # No covering table - Page API (READ)- **Quick Performance Test** - Reads first 100 records from each variant

/simpleTransMinimalAPI         # Minimal keys table - Page API (READ)

```- **Filtered Query Test** - Tests filtered queries (last 6 months)



### Test READ Query Example- **Aggregate Performance Test** - Tests SUM operations with SumIndexFields

```http

GET /simpleTransactionAPI?$filter=postingDate ge 2024-01-01- **Run All Performance Tests** - Comprehensive testing of all variantsThat's it! 🎉

```



Run this same READ query against all 4 variants and compare times.

No external tools needed! Just click an action and see the results.

## Testing Tips



### Do This ✅

## How to Use## What's IncludedThis extension lets you compare how different database keys and indexes affect API performance in Business Central. 

- Generate identical data in all tables

- Test READ operations with realistic volumes (10,000+ records)

- Run READ tests multiple times and average results

- Try different READ query patterns (filters, sorting, aggregates)### Generate Test Data

- Use the built-in AL READ tests for quick comparisons



### Avoid This ❌

**Option 1: All Tables at Once** (recommended)### 4 Table Variants

- Testing with different data in each table

- Using tiny datasets (<1,000 records)1. Open "API Performance Hub"

- Drawing conclusions from a single READ test

- Ignoring SQL execution plans2. Click "Populate ALL Table Variants"



### Sample Test Scenario3. Enter number of records



1. **Generate Data:** 10,000 records in all tables| Table | Strategy | Use Case |**The Setup:**### 4 Table Variants- **4 Table Variants** with different indexing strategies:

2. **Run Built-in READ Tests:** Click "Run All Read Performance Tests"

3. **Review Results:** Check which table variant has fastest READ times**Option 2: One Table at a Time**

4. **Optional:** Run same READ tests via external API calls

5. **Analyze:** Check SQL execution plans for deeper READ insights1. Open any list page|-------|----------|----------|



## Technical Details2. Actions → "Insert Test Data"



### Object Ranges3. Enter number of records| **Original** (91100) | Covering indexes + SumIndexFields | Best performance |- 4 tables with identical fields



- Tables: 91100-91105

- Pages: 91100, 91115-91118

- APIs: 91100-91114### Run Built-in Performance Tests| **No Covering** (91103) | Regular keys only | Standard approach |

- Codeunits: 91100-91107



### Architecture

1. Open "API Performance Hub"| **Minimal** (91104) | Primary key only | Worst case |- Each table uses a different indexing strategy- **Original with Covering Indexes** (91100) - Optimized with covering indexes and SumIndexFields  - Original with Covering Indexes (91100)

Built with SOLID principles:

- Interface-based design2. Navigate to **Performance Tests (AL Code)** group

- Factory pattern

- No code duplication3. Click one of the test actions:| **Alternative** (91105) | Different covering strategy | Alternative optimization |

- Easy to extend

   - **Quick Performance Test** - Fast comparison (100 records)

The **API Performance Tester** codeunit (91107) provides built-in READ performance testing using:

- `CurrentDateTime` for precise timing measurements   - **Filtered Query Test** - Real-world filtering scenario- 12 API endpoints to test performance

- `Duration` data type for calculating elapsed READ time

- Comparison of Page API READ speed vs Query API READ speed   - **Aggregate Performance Test** - SUM operations comparison

- Testing all 4 table variants with identical READ operations

- **All tests are READ-ONLY** - no insert, update, or delete operations   - **Run All Performance Tests** - Complete benchmark### 12 API Endpoints



### Requirements4. View results in a message dialog showing timings in milliseconds



- Business Central 26.0 or later- Tools to generate test data- **No Covering Indexes** (91103) - Regular keys only  - No Covering Indexes (91103)



### Test Data### Test with External Tools (Optional)



All test records have Document No. starting with "TEST-"Each table has 3 APIs:



## AuthorYou can also test the APIs using Postman, Power BI, or other HTTP clients:



**Steven Renders**  ```http- **Page API** - Standard OData access

Version: 1.0.0.0

GET https://[environment]/api/v2.0/companies([id])/simpleTransactionAPI

---

```- **Query API** - Query-based access

**Need Help?** Check the comments in the AL code - they explain everything.



### Clean Up Data- **Aggregate API** - Pre-aggregated data**Why?** To see which indexing strategy works best for your specific queries.- **Minimal Keys** (91104) - Only primary key (worst-case scenario)  - Minimal Keys (91104)



- **Delete Test Data** - Removes records starting with "TEST-"

- **Delete All Data** - Removes everything (careful!)

### Pages

## API Endpoints



### Pattern

```- **API Performance Hub** - Central dashboard---- **Alternative Covering Strategy** (91105) - Different covering approach  - Alternative Covering Strategy (91105)

https://[bc-url]/api/v2.0/companies([id])/[endpoint]

```- **4 List Pages** - One for each table (read-only, newest first)



### Examples

```

/simpleTransactionAPI          # Original table - Page API## How to Use

/simpleTransactionQuery        # Original table - Query API

/simpleTransNoCoversAPI        # No covering table - Page API## Quick Start

/simpleTransMinimalAPI         # Minimal keys table - Page API

```### Generate Test Data



### Test Query Example

```http

GET /simpleTransactionAPI?$filter=postingDate ge 2024-01-01**Option 1: All Tables at Once** (recommended)

```

1. Open "API Performance Hub"1. Install the extension### 12 API Endpoints- **12 API Endpoints** (3 per table variant):

Run this same query against all 4 variants and compare times.

2. Click "Populate ALL Table Variants"

## Testing Tips

3. Enter number of records2. Search for **"API Performance Hub"**

### Do This ✅



- Generate identical data in all tables

- Test with realistic volumes (10,000+ records)**Option 2: One Table at a Time**3. Click **"Populate ALL Table Variants"**Each table variant has 3 APIs:  - Page APIs for standard OData access

- Run tests multiple times and average results

- Try different query patterns (filters, sorting, aggregates)1. Open any list page

- Use the built-in AL tests for quick comparisons

2. Actions → "Insert Test Data"4. Enter a number (try 10,000 records)

### Avoid This ❌

3. Enter number of records

- Testing with different data in each table

- Using tiny datasets (<1,000 records)5. Test the APIs with Postman or Power BI- **Page API** - Standard OData page-based access  - Query APIs for optimized queries

- Drawing conclusions from a single test

- Ignoring SQL execution plans### Clean Up Data



### Sample Test Scenario6. Compare response times



1. **Generate Data:** 10,000 records in all tables- **Delete Test Data** - Removes records starting with "TEST-"

2. **Run Built-in Tests:** Click "Run All Performance Tests"

3. **Review Results:** Check which table variant is fastest- **Delete All Data** - Removes everything (careful!)- **Query API** - Optimized query-based access  - Aggregate Query APIs for pre-aggregated data

4. **Optional:** Run same tests via external API calls

5. **Analyze:** Check SQL execution plans for deeper insights



## Technical Details## API EndpointsThat's it! 🎉



### Object Ranges



- Tables: 91100-91105### Pattern- **Aggregate Query API** - Pre-aggregated data with SUM operations

- Pages: 91100, 91115-91118

- APIs: 91100-91114```

- Codeunits: 91100-91107

https://[bc-url]/api/v2.0/companies([id])/[endpoint]---

### Architecture

```

Built with SOLID principles:

- Interface-based design- **Test Data Generation**:

- Factory pattern

- No code duplication### Examples

- Easy to extend

```## What's Included

The **API Performance Tester** codeunit (91107) provides built-in performance testing using:

- `CurrentDateTime` for precise timing measurements/simpleTransactionAPI          # Original table - Page API

- `Duration` data type for calculating elapsed time

- Comparison of Page APIs vs Query APIs/simpleTransactionQuery        # Original table - Query API### Test Data Generation  - Generate test records for performance testing

- Testing all 4 table variants with identical operations

/simpleTransNoCoversAPI        # No covering table - Page API

### Requirements

/simpleTransMinimalAPI         # Minimal keys table - Page API### 4 Table Variants

- Business Central 26.0 or later

```

### Test Data

- Generate thousands of test records  - Populate all variants with identical data for fair comparison

All test records have Document No. starting with "TEST-"

### Test Query Example

## Author

```http| Table | Strategy | Use Case |

**Steven Renders**  

Version: 1.0.0.0GET /simpleTransactionAPI?$filter=postingDate ge 2024-01-01



---```|-------|----------|----------|- Populate all variants with identical data  - Bulk insert/delete operations



**Need Help?** Check the comments in the AL code - they explain everything.


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