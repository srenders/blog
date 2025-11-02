# Directions EMEA 2025 – Reporting (AL Samples)

A curated set of Microsoft Dynamics 365 Business Central AL samples that deep‑dive into report objects and layouts. The app demonstrates multiple report patterns (List, Union, Join, Query, Document/RDLC & Word, Integer, Buffer, Switch Layout, Item Availability, and Add‑in) along with a convenient overview page that previews reports to PDF and stores the file as an attachment.

- Name: `Directions Emea 2025 Reporting`
- Publisher: `Steven Renders`
- Version: `1.0.0.0`
- Target application: `26.0.0.0` (Business Central v26)
- Object ID range: `70100..70149`

## What’s inside

Top-level folders in `src/`:

- `pages/`
  - `Report Overview` (page 70120): lists custom reports and lets you:
    - Generate a PDF preview to a factbox (stored via `Document Attachment`).
    - Run the selected report with the standard viewer.
  - `Report PDF Attachment Factbox` (page 70124): shows and opens the generated PDFs.
- `tables/`
  - `Report PDF Storage` (table 70122): lightweight anchor to tie a report ID to its last generated PDF.
- `codeunits/`
  - `Report PDF Attachment` (codeunit 70123): helper to import PDF streams and persist them as `Document Attachment` media.
- `reports/`
  - `01 list/` – List report basics.
  - `02 union/` – Combine datasets from multiple sources.
  - `03 join/` – Relate data across tables.
  - `04 query/` – Drive a report from an AL `query` object.
  - `05 document/` – Document reports (RDLC/Word); includes Sales Invoice examples.
  - `06 integer/` – Use the virtual `Integer` table to synthesize rows.
  - `07 buffer/` – Populate a buffer table first; report over the prepared dataset.
  - `08 switchlayout/` – Ship multiple layouts and switch them at runtime:
    - `RunReport` (page 70100) exposes actions to toggle between layout names
      via `UpdateReportLayouts` (codeunit 70100) and run `ItemList`.
    - Includes `ItemListWordOrange.docx` and `ItemListWordBlue.docx` Word layouts.
  - `09 Item Availability/` – Item availability sample with a customer‑focused layout.
  - `10 add in/` – Demonstrates a report add‑in scenario.
- `apis/` – Queries and page extensions used by samples or for data exposure.
- `PowerBI/` – Optional artifacts for demos.

## Prerequisites

- A Business Central environment compatible with Application `26.0.0.0` (v26 or later).
- VS Code with the AL Language extension.
- Access to publish extensions to your target (Sandbox, Docker container, or Online Sandbox).

## Getting started

1) Open the folder in VS Code.
2) Configure connection settings (only once per machine/workspace):
   - Press Ctrl+Shift+P → “AL: Initialize Workspace” to create `.vscode/launch.json`.
   - Update `server`, `serverInstance`, `authentication`, `environmentType`, and `schemaUpdateMode` as needed.
   - Press Ctrl+Shift+P → “AL: Download Symbols”.
3) Publish and run:
   - Press F5 to publish with debugging (or Ctrl+F5 for “Publish Without Debugging”).
   - After publish, open the search (Tell Me) in BC and look for:
     - `Report Overview - Directions EMEA 2025` (page 70120)
     - `DEMO - RunReport` (page 70100) for the switch‑layout demo

### Using the Report Overview page

- Select any report in the list (IDs in the 70000–99999 custom range).
- Choose “Generate (PDF)” to render the report to PDF; it’s attached and shown in the factbox.
- Choose “Run Report” to open the standard report viewer.
- In the factbox you can click the file name to export, or use the `View` action to open it in the browser.

### Switch layout demo (Word layouts)

- Open `DEMO - RunReport` (page 70100).
- Use actions `RunItemList` and `RunItemListUpdated`:
  - They call `UpdateReportLayouts.UpdateTenantLayoutSelection` to select between
    `ItemListWordOrange` and `ItemListWordBlue` layouts for `report::ItemList`, and then run the report.
- This demonstrates how to set tenant‑level layout selection programmatically.

## Folder map (quick reference)

- `src/pages/ReportOverview.page.al` – Page 70120 list + actions to preview/run
- `src/pages/ReportPDFAttachmentFactbox.page.al` – Page 70124 factbox to browse PDFs
- `src/tables/ReportPDFStorage.Table.al` – Table 70122 anchor for attachments
- `src/codeunits/ReportPDFAttachment.Codeunit.al` – Codeunit 70123 to import/view PDFs
- `src/reports/08 switchlayout/RunReport.page.al` – Page 70100 demo
- `src/reports/08 switchlayout/UpdateReportLayouts.codeunit.al` – Codeunit 70100 tenant layout selection

## Notes and tips

- If symbols fail to download, verify your `launch.json` target version matches `application: 26.0.0.0` and your BC environment version.
- The overview page filters on custom reports (Object ID 50000..99999). Ensure your sample reports fall in this range so they appear.
- For best results, load a standard CRONUS demo company so that list/join/query/document samples have data.


## License and credits

- Publisher: Steven Renders — for educational/demo purposes at Directions EMEA 2025.
- No license is included in this repository. If you intend to reuse code beyond demos, please contact the publisher or add an appropriate license.

---

Made with ❤️ for learning and exploring Business Central reporting. Contributions and suggestions are welcome.
