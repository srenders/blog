# Presenter Demo Notes

## Measurement

Show:

Open `PerfMeasurement.Codeunit.al` and `PerfDemoResult.Table.al`, then show `PerfDemoRunner.Codeunit.al` for the data-access actions.

Ask:

What evidence would convince us that one implementation is better?

Run:

Clear measurements, run any baseline, then its optimized pair.

Observe:

Duration, SQL Statements, Rows Read, and Result Value.

Explain:

`SessionInformation` provides evidence about work performed by the current session. Timing alone is not enough.

Takeaway:

Measure the runtime and data-access behavior, not how fast the code looks in the editor.

## Partial Records

Show:

`Bad_FullRecordRead` and `Good_PartialRecordRead` in `PerfDataAccessDemos.Codeunit.al`.

Ask:

How many fields does this loop actually need?

Run:

Full record read, then SetLoadFields.

Observe:

Rows read, SQL activity, duration, and equal result values.

Explain:

`SetLoadFields(Amount)` tells Business Central which normal field is needed.

Takeaway:

Do not load a complete record when the code needs only a small part of it.

## JIT Load Trap

Show:

`Bad_JitLoadTrap` in `PerfDataAccessDemos.Codeunit.al`.

Ask:

What happens when code accesses a field it did not request?

Run:

JIT load trap.

Observe:

SQL statements and rows read, preferably with the SQL information debugger.

Explain:

`SetLoadFields` is not magic. Accessing an unloaded field can require another data access. The demo uses `FieldRef` to keep the deliberately bad access runnable without hiding the lesson behind a compiler error.

Takeaway:

Partial records require the complete field access path to be understood.

## Find Intent and Set-Based Operations

Show:

`Good_GetByPrimaryKey`, `Good_FindFirst`, `Bad_FindSetForOne`, `Bad_LoopSum`, and `Good_CalcSums`.

Ask:

Does the code need one record, an iterable set, or an aggregate?

Run:

Get by primary key, FindFirst, FindSet consume one, Loop SUM, and CalcSums.

Observe:

Result equivalence, rows read, and SQL statements. Do not claim one API is always faster.

Explain:

The operation should express intent. `CalcSums` lets the database calculate an aggregate instead of moving every matching row through AL.

Takeaway:

Choose the operation that describes the work the code actually needs.

## FlowFields

Show:

`Bad_CalcFieldsInLoop` and `Good_SetAutoCalcFields` in `PerfFlowFieldDemos.Codeunit.al`.

Ask:

Is a FlowField a stored value that is already present on every Customer record?

Run:

CalcFields in loop, then SetAutoCalcFields.

Observe:

SQL activity and rows read. Results depend on available Customer ledger data.

Explain:

A FlowField is a calculation. The two implementations ask the platform to perform that calculation at different points.

Takeaway:

Treat FlowFields as database work, not as free fields.

## Keys and Filters

Show:

`Good_IndexedFilter` in `PerfDataAccessDemos.Codeunit.al` and `PerfDemoEntry.Table.al`, especially `CustomerOpen` and `CategoryPostingDate`.

Ask:

What key can support these filters, and what does maintaining that key cost on insert/update?

Run:

Run **Indexed filters** and the category-based aggregate demos, then inspect SQL behavior.

Observe:

Rows read and query shape, not only elapsed time.

Explain:

Simple `SetRange` calls have an index dependency. More indexes are not automatically better because every index has write and maintenance cost.

Takeaway:

Design keys for real access patterns and validate them with measurements.

## TextBuilder and Dictionary

Show:

`Bad_TextConcatenation`, `Good_TextBuilder`, `Bad_TemporaryRecordLookup`, and `Good_DictionaryLookup` in `PerfALDemos.Codeunit.al`.

Ask:

What abstraction does this problem actually require: record semantics or key/value lookup?

Run:

Run each pair with the substantial default iteration count.

Observe:

Duration and equal result values. Do not promise a fixed ratio.

Explain:

Repeated concatenation can create repeated string work. A temporary record is database-shaped; a Dictionary directly expresses an in-memory key/value lookup.

Takeaway:

Use the data structure that matches the problem.

## Page Performance and Background Tasks

Show:

`PerfPagePerformanceBad.Page.al`, `PerfPagePerformanceGood.Page.al`, and `PerfBackgroundTask.Codeunit.al`.

Ask:

How many records can be displayed, and how much work runs once per record?

Run:

Open both page-performance actions and compare scrolling/rendering. Then run the background task while interacting with the playground.

Observe:

The page remains usable while the child session calculates its result. This is responsiveness, not proof that the calculation itself became faster.

Explain:

Work in `OnAfterGetRecord` can multiply with every displayed row. A background task moves work out of the foreground session but still consumes resources and time.

Takeaway:

Asynchronous work can improve perceived responsiveness without reducing execution cost.

## Report Performance (Optional)

Show:

Actual ProcessingOnly Report objects: `Perf Report Nested Loops` (Report 70210) and `Perf Report Partial Records` (Report 70211), invoked via `PerfReportDemos.Codeunit.al`. Open Report 70210 in VS Code and show the Customer dataitem with no SetLoadFields, per-record CalcFields, and nested PerfDemoEntry query logic in OnAfterGetRecord. Then show Report 70211 with its OnPreDataItem customer pre-filtering, SetLoadFields, and SetAutoCalcFields.

Ask:

How many database round-trips does this report pattern create? What happens as customer count grows? Is CalcFields free when it's in a Report dataitem?

Run:

**Report: nested loops**, then **Report: partial records**.

Observe:

Duration difference, SQL Statements (expect 2-5× difference with 10,000+ entries and many customers), and Rows Read comparison. Both return the same customer count, proving correctness. The nested loop pattern shows significantly higher SQL statements because it queries PerfDemoEntry separately for each customer.

Explain:

Reports often process master-detail relationships like Customer to PerfDemoEntry records. Report 70210 uses the anti-pattern: outer Customer dataitem with no SetLoadFields (full records), per-record CalcFields("Balance (LCY)"), and nested PerfDemoEntry query in OnAfterGetRecord. This creates N customers × M database queries each. Report 70211 uses the optimized pattern: pre-filter in OnPreDataItem to only customers with entries (using temp table), SetLoadFields("No.", Name), SetAutoCalcFields("Balance (LCY)"), and CalcSums for aggregation instead of looping. The optimized version touches fewer customers, loads partial records, batches FlowField calculations, and uses efficient set-based aggregation.

Takeaway:

Report performance starts with efficient data retrieval. Optimize the dataset generation pattern before worrying about layout rendering. The same partial record and set-based patterns apply to Reports as they do to codeunits.

## Events and Locking

Show:

`Bad_ModifyAllWithHiddenSubscriber` and `SlowSubscriber` in `PerfEventDemos.Codeunit.al`, then `Bad_LockEarly` and `Good_LockLate` in `PerfLockingDemos.Codeunit.al`.

Ask:

What work is hidden behind this apparently simple bulk operation, and when does the lock become necessary?

Run:

Toggle the subscriber, run ModifyAll, then compare Lock early and Lock late. Use two sessions for contention.

Observe:

SQL statements, rows read, duration, and behavior under concurrency.

Explain:

Event subscribers can add per-record work outside the call site. Preparing data before taking a lock reduces the time other sessions wait, but only controlled, playground-only records are touched.

Takeaway:

Fast in one session does not automatically mean fast under concurrency or event-driven execution.

## HttpClient

Show:

`Bad_SynchronousHttpRequest` in `PerfHttpClientDemos.Codeunit.al`.

Ask:

What is the current AL session doing while the external service responds?

Run:

Enter a safe, reachable URL in **HTTP demo URL**, then run **Run synchronous HttpClient demo**. Skip this action when no external service is available.

Observe:

Duration and the result row. A slow response keeps the foreground request waiting.

Explain:

`HttpClient.Get` is synchronous. External latency is part of the current execution unless the design deliberately moves the work elsewhere.

Takeaway:

An external dependency can make otherwise simple AL execution wait.

## Company-Open Initialization

Show:

`PerfCompanyOpenDemo.Codeunit.al`.

Ask:

Who pays if expensive work runs during company or session initialization?

Run:

Use **Enable company-open teaching flag** only to show the safe opt-in state. No event subscriber is executed.

Observe:

The code comments and the absence of an executable subscriber.

Explain:

Initialization work runs before normal user work begins, so every session can pay the cost. The implementation is intentionally disabled to keep the training extension pleasant to install and use.

Takeaway:

Do not put expensive work on the critical path of opening a company or session.
