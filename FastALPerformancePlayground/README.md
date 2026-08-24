# Fast AL Performance Playground

This dependency-free Business Central AL extension accompanies the developer session **Fast AL: Performance Patterns Every Business Central Developer Should Know**.

The playground makes AL performance behavior visible and measurable. It deliberately contains both inefficient and optimized implementations so the presenter can follow the workflow below.

## Session workflow

> Measure -> Understand -> Change -> Measure Again -> Validate

## What this app is

It is a safe, reproducible training environment for demonstrating where AL work is paid for: AL execution, SQL access, the UI, locking, events, and asynchronous sessions.

The workload uses a deliberately wide `Perf Demo Entry` table and deterministic sample rows. Measurement records duration, SQL statements, rows read, result value, notes, and the last run timestamp.

The data-access demos expose clean teaching methods such as `Bad_FullRecordRead`, `Good_PartialRecordRead`, `Bad_LoopSum`, and `Good_CalcSums`. `Perf Demo Runner` owns the measurement envelope for those actions so the performance pattern is easy to read in VS Code.

## Source navigation

The source tree is organized for live presentation and Quick Open:

- `src/Measurement` contains measurement and runner infrastructure.
- `src/Playground` contains the main page and measurement ListPart.
- `src/Data` contains playground tables and data generation.
- `src/Demos/DataAccess` contains partial records, JIT loading, and lookup intent.
- `src/Demos/SetBased` contains FlowField demonstrations.
- `src/Demos/ALPatterns` contains TextBuilder and Dictionary demonstrations.
- `src/Demos/Reports` contains actual Report objects demonstrating nested loops versus optimized filtering.
- `src/Demos/Events`, `src/Demos/Locking`, and `src/Demos/BackgroundTasks` contain hidden-cost examples.
- `src/Demos/PagePerformance`, `src/Demos/HttpClient`, and `src/Demos/CompanyOpen` contain the optional UI/platform demonstrations.

Useful Quick Open terms include `PartialRecord`, `JitLoad`, `CalcSums`, `FlowField`, `TextBuilder`, `Dictionary`, `Report`, `PagePerformance`, `Events`, `Locking`, `BackgroundTask`, `HttpClient`, and `CompanyOpen`.

## What this app is not

This is not production code. Some implementations are intentionally inefficient for educational purposes. Do not copy the `Bad_...` examples into production applications, and do not interpret a single timing as a universal performance guarantee.

## Preparation

1. Open the project in VS Code with the AL Language extension and a Business Central 28 / runtime 17 symbol workspace.
2. Publish and install the extension in a sandbox with the required AL symbols.
3. Open **Fast AL - Performance Playground**.
4. Ensure the sandbox contains at least one Customer; FlowField examples are more useful when Customer ledger data exists.
5. Set **Entries to generate** to a suitable workload, for example `1000`, `10000`, or `100000`.
6. Choose **Generate demo entries**. The generator replaces only playground entries.
7. Optionally run a warm-up action so cache effects can be discussed separately.
8. Choose **Clear measurements** before a clean comparison.
9. Run the baseline implementation.
10. Run the optimized implementation.
11. Compare duration, SQL statements, rows read, and result value in the Measurements part.

**Clear demo entries** asks for confirmation and deletes only the playground table. It never deletes standard Customer or transaction data.

## Recommended presentation order

1. Measurement
2. Partial Records
3. JIT Load Trap
4. Set-Based Operations
5. FlowFields
6. Keys and Filters
7. AL Data Structures
8. Reports (Optional)
9. Page Performance
10. Events
11. Locking
12. Background Tasks
13. Performance Validation

## Available demonstrations

- Partial records: complete record access versus `SetLoadFields`.
- JIT load trap: request one field, then access another field dynamically.
- Find intent: `FindFirst` for one record and `FindSet` for iteration.
- Set-based work: row-by-row sum versus `CalcSums` and the SIFT key.
- FlowFields: `CalcFields` inside a loop versus `SetAutoCalcFields`.
- Keys and filters: the demo table exposes Customer/Open and Category/Posting Date access patterns.
- Text handling: repeated concatenation versus `TextBuilder`.
- AL collections: temporary record lookup versus `Dictionary` lookup.
- Reports: ProcessingOnly Report objects (70210 and 70211) demonstrating nested loop per-record queries versus pre-filtered datasets with SetLoadFields and CalcSums aggregation.
- Events: `ModifyAll` with an optional deliberately expensive subscriber.
- Locking: early versus late locking on playground data. Use two sessions to discuss contention.
- Background tasks: perceived responsiveness versus actual calculation cost.
- Synchronous `HttpClient`: an opt-in external request that demonstrates foreground blocking.
- Company-open initialization: a presentation-only disabled example showing why startup work is dangerous.

The HTTP demonstration requires a URL entered in the playground and may fail when the service is unavailable. It is never required for normal installation or use. The company-open example has no executable subscriber by design, so opening a company is never delayed by this training extension.

For the HTTP demonstration, use a harmless HTTPS endpoint approved for the sandbox, confirm that the environment allows outbound requests, and provide any required extension/tenant permission or allow-list configuration. Do not use a production endpoint or an endpoint that changes data. Leave **HTTP demo URL** empty when demonstrating the rest of the playground.

## Measurement disclaimer

Actual numbers vary with Business Central version, database size, cache state, installed extensions, tenant load, query plans, and environment configuration. The important result is the relative behavior and access pattern, especially SQL statements and rows read, not reproducing a number from a slide.

`SessionInformation.SqlStatementsExecuted()` and `SessionInformation.SqlRowsRead()` are sampled immediately before and after the demo logic. Result persistence happens after those counters are captured, so writing the measurement does not inflate the demo's SQL delta.

## Target

- Business Central version 28 / AL runtime 17.0
- Object range `70200..70299`
- No extension dependencies
