# PowerBI_Demos — Business Central AL Extension

Demo extension built for the **D365BC Bootcamp 2026** session:  
*"Beyond the Ledger — Explore Business Central's Data Analytics with Power BI"*

**Publisher:** Steven Renders  
**Version:** 1.0.0.0  
**BC Application:** 27.0.0.0+  
**ID Range:** 80200–80249

---

## Overview

This extension demonstrates the main patterns for integrating Power BI reports and visuals into Business Central pages. It also exposes a set of custom OData API endpoints (publisher: `solutize`, group: `powerBI`, version `v1.1`) that can be connected to Power BI as data sources.

---

## Features

### 1. Power BI Embedded Report Page

**Page 80209 — "PBI Item Availability Report"** (`src/pages/ItemAvailabilityReport.Page.al`)

A standalone Business Central page that embeds a full Power BI report. The page is locked to the report configured in the `var` section — users cannot switch to a different report from the UI.

- Uses `"Power BI Embedded Report Part"` with `SetFullPageMode(true)` for a full-page experience.
- Performs first-time Power BI setup via the `"Power BI Embed Setup Wizard"` if needed.
- Persists report configuration in `"Power BI Displayed Element"` (once per user).
- Locks the context so the report cannot be changed from the UI.

**Before deploying**, replace the placeholder values in the `var` section:

| Variable | Description |
|---|---|
| `vReportId` | Your Power BI Report GUID (from the report URL) |
| `vReportEmbedUrl` | Embed URL (from Power BI Online: *File > Embed report > Website or portal*) |
| `vReportPage` | Page/tab name to display by default (leave empty for the first page) |

---

### 2. Power BI FactBox on Item Card

**Page Extension 80210 — "PBI Item Card Factbox"** (`src/page ext/ItemCard.PageExt.al`)

Embeds a single Power BI report **visual** as a FactBox on the standard Item Card page. This is the simplest embedding pattern — a single `AddReportVisualForContext` call in `OnOpenPage` is all that is required.

**Before deploying**, replace the three placeholder strings in `OnOpenPage`:

| Parameter | Description |
|---|---|
| Report ID | GUID of your Power BI report |
| Page ID | Page/section ID (e.g. `ReportSection1`) |
| Visual ID | Visual ID from the *Link to this Visual* URL |

> **How to find the IDs:** In Power BI Online, hover over the visual → three-dots menu (…) → *Share* → *Link to this Visual* → copy. The URL contains all three values.

---

### 3. Item List Enhancements

**Page Extension 80200 — "PBI Item List"** (`src/page ext/ItemList.PageExt.al`)

Extends the standard Item List page with:

- **Availability column** — calculated field showing `Inventory + Qty. on Purch. Order - Qty. on Sales Order`, with conditional styling (Standard / Attention / Favorable).
- **Calculate Availability Selected** action (`Shift+Ctrl+A`) — sums availability across selected items.
- **Open Power BI Report (Expanded)** action — opens the full Item Availability report in a full-screen `"Power BI Element Card"` using a temporary `"Power BI Displayed Element"` record (no persisted user config).
- **Open Power BI Visual (Expanded)** action — opens a specific report visual in a full-screen card view.

**Before deploying**, replace all `<YOUR-...>` placeholder values in both actions.

---

### 4. Custom API Endpoints

All queries use `QueryType = API`, `DataAccessIntent = ReadOnly`.  
Base URL pattern: `/api/solutize/powerBI/v1.1/<entitySetName>`

| Object | Entity Set | Source Table | Key Columns |
|---|---|---|---|
| Query 80200 | `items` | Item | No., Description, Category, Unit Price/Cost, Reorder Point |
| Query 80201 | `itemledgers` | Item Ledger Entry | Item No., Posting Date, Location, Quantity (Sum) |
| Query 80202 | `purchases` | Purchase Line | Item No., Location, Expected Receipt Date, Quantity (Sum) |
| Query 80203 | `sales` | Sales Line | Item No., Location, Shipment Date, Quantity (Sum) |
| Query 80204 | `locations` | Location | Code, Name |
| Query 80205 | `valueentriesqry` | Value Entry | Item No., Posting Date, Sales Amount Actual (Sum), Valued Quantity (Sum) |
| Query 80206 | `generalLedger` | G/L Entry | Account No., Document, Source, Dimension Set ID, Amount (Sum) |
| Query 80207 | `defaultDimensions` | Default Dimension | Table ID, No., Dimension Code/Value |
| Query 80208 | `dimensionSetEntries` | Dimension Set Entry | Dimension Code/Name, Set ID, Value Code/Name |
| Page 80200 | `valueentriespage` | Value Entry | Item No., Entry Type, Location, Posting Date, Sales Amount, Valued Qty |

---

### 5. Power BI Report File

**`src/Power BI/Item Availability.pbix`** — A sample Power BI Desktop report pre-built to connect to the custom API endpoints above.

---

## Prerequisites

- Business Central 2024 Wave 2 (v27) or later
- Power BI Pro licence (or Premium capacity) for the user embedding reports
- Power BI integration enabled in BC (`Assisted Setup > Set up Power BI integration`)

## Building and Deploying

1. Open the workspace in VS Code with the AL Language extension installed.
2. Set the correct `launch.json` target environment.
3. Replace all `<YOUR-...>` placeholder values in the source files.
4. Press `Ctrl+Shift+B` to compile, then `F5` to publish.

## References

- [BCTech — Embed Your PBI App](https://github.com/microsoft/BCTech/tree/master/samples/PowerBi/EmbedYourPBIApp)
- [BCTech — PBI23 Samples](https://github.com/microsoft/BCTech/tree/master/samples/PowerBi/PBI23samples)
- [Power BI REST API — Get Reports](https://learn.microsoft.com/en-us/rest/api/power-bi/reports/get-reports)
