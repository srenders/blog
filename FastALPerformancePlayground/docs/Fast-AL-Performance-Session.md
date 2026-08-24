# Fast AL: Performance Patterns Every Business Central Developer Should Know

> Session design for a 60-minute Business Central developer session.

The session’s central idea would be:

**Every line of AL has a cost. Good performance starts when you understand where that cost is paid: AL, SQL, UI, locking, or an external service.**

That aligns very closely with Microsoft’s developer performance guidance, which organizes optimization around efficient pages, web services, AL patterns, data access, testing/validation, tooling, and profiling. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/performance/performance-developer))

### Session overview

My preferred title:

**Fast AL: Performance Patterns Every Business Central Developer Should Know**

#### Subtitle

**Measure it. Understand it. Fix it. Prove it.**

The learning objectives would be that, after 60 minutes, attendees can identify likely performance bottlenecks in AL, understand how common AL patterns translate into database work, apply several high-impact optimizations, use profiling to find bottlenecks, and validate that an optimization actually improved performance.

## The complete 60-minute session

I’d aim for roughly **30–35 slides**, but many slides should be visual, code, or a single question. You absolutely do not want 35 information-dense slides.

#### The overall structure

| Time | Part |
| --- | --- |
| 0–5 | What does “slow” mean? |
| 5–10 | Measure before optimizing |
| 10–28 | Efficient data access |
| 28–37 | Efficient AL patterns |
| 37–45 | UI performance |
| 45–52 | Hidden killers: events, locking, integrations |
| 52–57 | Prove the improvement |
| 57–60 | Performance rules to take home |

## 1. Opening — “Business Central is slow”

**Slide 1 — Title**

**Fast AL**  
Performance Patterns Every Business Central Developer Should Know

Very little else.

Then ask the room:

“How many of you have ever received a ticket saying only: Business Central is slow?”

You’ll probably get half the room smiling immediately.

### Slide 2 — The world's worst bug report

Huge text:

**Business Central is slow.**

Underneath:

**Where do you start?**

Don't answer immediately.

Ask the audience.

You’ll probably hear:

- SQL
- profiler
- debugger
- telemetry
- extension
- database
- restart BC 😄
This establishes the problem.

### Slide 3 — “Slow” has many meanings

Show something like:

```text
                 USER
                  |
                  v
             PAGE / API
                  |
                  v
                 AL
               /    \
              v      v
            SQL    EXTERNAL
             |
             v
          LOCKING
```

Then explain:

A slow Business Central experience might be caused by:

- AL execution
- SQL calls
- rows read
- locks
- FlowFields
- rendering
- event subscribers
- external services
- concurrency
Therefore:

**Performance optimization without measurement is guessing.**

Microsoft explicitly recommends profiling and performance validation rather than relying on assumptions. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-profiler-overview))

## 2. Measure before optimizing

### Slide 4 — Rule #1

Huge:

**Measure. Don't guess.**

Then introduce the toolbox:

```text
Problem
   ↓
Profiler
   ↓
SQL / rows read / calls
   ↓
Change
   ↓
Measure again
```

Mention:

- AL Profiler
- Performance Profiler in the client
- debugger database statistics
- Application Insights
- SessionInformation
- BC Performance Toolkit
Don't explain everything yet.

Tell them:

“We will come back to these tools at the end. For now, we need to understand what we're looking for.”

## 3. Your AL isn't what SQL sees

This is where the session becomes interesting.

### Slide 5 — Two developers looking at the same code

Show:

```al
Customer.SetRange(Blocked, Customer.Blocked::" ");
Customer.FindSet();

repeat
    // ...
until Customer.Next() = 0;
```

Ask:

“How expensive is this code?”

Answer:

**You can't tell yet.**

It depends on:

- number of records
- fields loaded
- filter selectivity
- available indexes
- FlowFields
- table extensions
- what happens inside the loop
This establishes your core mental model.

Microsoft’s database-performance documentation specifically explains that Get, Find, FindSet, and Next have different retrieval behaviors and should be chosen according to how records will actually be consumed. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/optimize-sql-al-database-methods-and-performance-on-server))

### Slide 6 — Think in SQL work

Large text:

Stop asking:**“Is this AL elegant?”**

Then:

Start asking:**“What does this make the server do?”**

This phrase should recur throughout the session.

## 4. Get vs FindFirst vs FindSet

### Slide 7 — Choose the right retrieval method

Show:

```text
Customer.Get(CustomerNo);
```

versus:

```al
Customer.SetRange("Post Code", PostCode);
Customer.FindFirst();
```

versus:

```al
Customer.SetRange(Blocked, Customer.Blocked::" ");
Customer.FindSet();
```

Then explain conceptually:

**Get**I know the primary key and need one record.

**FindFirst**I need one matching record.

**FindSet**I expect to iterate a set of records.

Microsoft documents the methods as optimized for different retrieval scenarios. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/optimize-sql-al-database-methods-and-performance-on-server))

Don't turn this into a reference manual.

The message is:

**Tell Business Central what you intend to do.**

## 5. Demo 1 — The bad loop

Now start your running demo.

Create something deliberately inefficient.

For example:

```al
procedure CalculateCustomerStatistics()
var
    Customer: Record Customer;
    SalesHeader: Record "Sales Header";
    TotalAmount: Decimal;
begin
    if Customer.FindSet() then
        repeat
            SalesHeader.Reset();
            SalesHeader.SetRange("Sell-to Customer No.", Customer."No.");

            if SalesHeader.FindSet() then
                repeat
                    SalesHeader.CalcFields(Amount);
                    TotalAmount += SalesHeader.Amount;
                until SalesHeader.Next() = 0;
        until Customer.Next() = 0;
end;
```

Tell the audience:

“We're going to keep improving this code throughout the session.”

This gives the entire hour coherence.

## 6. SetLoadFields — stop loading what you don't use

This should be one of your biggest topics.

### Slide 8 — A record is wider than you think

Put this on screen:

```al
Item.FindSet();
```

Ask:

“What did we just load?”

Most developers instinctively think “Item.”

But an Item record can contain many fields plus table-extension fields.

Introduce partial records.

Microsoft recommends loading only the fields required by the operation, with particularly strong gains possible when tables have extensions. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-partial-records))

### Slide 9 — SetLoadFields

Before:

```al
if Item.FindSet() then
    repeat
        Sum += Item."Standard Cost";
    until Item.Next() = 0;
```

After:

```al
Item.SetLoadFields("Standard Cost");

if Item.FindSet() then
    repeat
        Sum += Item."Standard Cost";
    until Item.Next() = 0;
```

Explain:

You are saying:

“I don't want an Item.I want Standard Cost from Items.”

That framing makes the API easy to remember.

### Slide 10 — Why table extensions matter

Show visually:

```text
ITEM

Base table
├── No.
├── Description
├── Cost
├── Inventory
├── ...
│
├── Extension A fields
├── Extension B fields
├── Extension C fields
└── Extension D fields
```

Then:

```text
What do I need?

→ No.
→ Standard Cost
```

Partial-record performance becomes increasingly important as the table becomes wider. Microsoft explicitly calls table extensions one of the scenarios where loading fewer fields can have the most impact. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-partial-records))

## 7. The SetLoadFields trap — JIT loads

### Slide 11 — Spot the problem

```al
Customer.SetLoadFields(Name);
Customer.FindFirst();

Message(
    '%1 lives at %2',
    Customer.Name,
    Customer.Address);
```

Ask:

“Optimized?”

Audience says yes/no.

Reveal:

Address wasn't loaded.

Business Central may have to perform another data load.

Explain **JIT loading** briefly.

The lesson:

**SetLoadFields is not magic. Load what you'll actually use.**

## 8. Set-based operations

This should be your second major performance idea.

### Slide 12 — SQL is really good at sets

Show:

```al
GLEntry.FindSet();

repeat
    TotalAmount += GLEntry.Amount;
until GLEntry.Next() = 0;
```

versus:

```al
GLEntry.CalcSums(Amount);
TotalAmount := GLEntry.Amount;
```

Then huge:

**Move work to the database when the database can do it better.**

Microsoft's developer guidance explicitly recommends set-oriented methods rather than unnecessary record-by-record processing. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

## 9. CalcFields vs SetAutoCalcFields

### Slide 13 — The suspicious repeat

```al
if Customer.FindSet() then
    repeat
        Customer.CalcFields("Balance (LCY)");

        if Customer."Balance (LCY)" > 100000 then
            // ...
    until Customer.Next() = 0;
```

Then ask:

“How many calculations are happening?”

Introduce:

```text
Customer.SetAutoCalcFields("Balance (LCY)");
```

Explain that it can allow the required FlowField calculation to become part of the retrieval strategy rather than manually issuing work repeatedly.

Again, the rule isn't “always SetAutoCalcFields.”

The rule is:

**Think about how often you're asking the server to calculate something.**

## 10. FlowFields and SIFT

### Slide 14 — FlowFields are not fields

Put:

```text
FlowField ≠ stored value
```

Then:

```text
FlowField
    ↓
Calculation
    ↓
SQL
    ↓
potential SIFT
```

This distinction is extremely important.

Developers often treat:

```text
Customer."Balance (LCY)"
```

like any other field.

It isn't.

### Slide 15 — SIFT

Explain conceptually rather than deeply:

Without an optimized aggregate:

```text
Need SUM
    ↓
Read a lot
    ↓
Calculate
```

With the appropriate indexed aggregate structure:

```text
Need SUM
    ↓
Use maintained aggregate
```

Tell them:

“SIFT makes reads cheap by making writes slightly more expensive.”

That leads nicely into index trade-offs.

## 11. Keys and indexes

### Slide 16 — This code has a hidden dependency

```al
SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
SalesLine.SetRange("Document No.", OrderNo);
SalesLine.SetRange(Type, SalesLine.Type::Item);
```

Ask:

“What is the hidden dependency?”

Answer:

**The index structure.**

### Slide 17 — A useful key

```text
key(OrderLines;
    "Document Type",
    "Document No.",
    Type)
{
}
```

Explain:

Filters and sort requirements should align sensibly with keys.

But then immediately show the warning.

### Slide 18 — More indexes ≠ more performance

Show:

```text
READS          WRITES

More indexes   ↑ faster potential reads
               ↓ more maintenance
```

Every insert/update/delete has to maintain indexes.

So:

**An index is an investment. Make sure the query pays you back.**

Don't encourage developers to add indexes randomly.

## 12. FindSet and changing filters

A nice advanced tip.

### Slide 19 — Don't sabotage your own result set

Concept:

```al
Record.FindSet();

repeat
    ...
    Record.SetRange(...);
until Record.Next() = 0;
```

Explain that modifying filters during iteration can force Business Central to abandon its current result set and fetch again.

Keep this short but memorable.

## 13. Built-in data structures

Move from database optimization to AL itself.

### Slide 20 — Do you actually need a temporary table?

Show:

```text
TempBuffer: Record "My Buffer" temporary;
```

Then alternative scenarios:

```text
Dictionary of [Code[20], Decimal]
```

or:

```text
List of [Code[20]]
```

Explain:

Use a temporary record when you need record semantics.

Use:

- Dictionary for key/value lookup
- List for collections
when that's what the problem actually is.

Microsoft's developer performance guidance explicitly recommends using optimized built-in AL data structures appropriately. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

## 14. TextBuilder

### Slide 21 — Death by 10,000 concatenations

```text
foreach CustomerNo in CustomerNos do
    CsvText += CustomerNo + ',';
```

versus:

```al
foreach CustomerNo in CustomerNos do begin
    Builder.Append(CustomerNo);
    Builder.Append(',');
end;
```

Then explain Microsoft's useful rule of thumb:

For only a few concatenations, regular Text can be perfectly fine.

For repeated concatenation or loops, TextBuilder is generally the better fit. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

Spend about a minute here.

## 15. Async processing

### Slide 22 — Fast and responsive are not the same thing

Show:

```text
Operation = 3 seconds

Synchronous:
User waits 3 sec

Asynchronous:
Page appears
background work happens
```

Then:

“Did we make the calculation faster?”

No.

“Did we make the application feel faster?”

Yes.

This is a very important performance distinction.

## 16. Page performance

Now move back toward user experience.

### Slide 23 — The most dangerous page trigger

Huge:

```al
trigger OnAfterGetRecord()
```

Then perhaps:

```text
Called.
Again.
And again.
And again.
```

### Slide 24 — What's wrong with this page?

Put intentionally bad code:

```al
trigger OnAfterGetRecord()
var
    SalesHeader: Record "Sales Header";
begin
    Rec.CalcFields("Balance (LCY)");

    SalesHeader.SetRange(
        "Sell-to Customer No.",
        Rec."No.");

    OpenOrderCount := SalesHeader.Count();

    MyWebService.GetScore(Rec."No.");

    CurrPage.Update();
end;
```

Ask the room:

“How many performance crimes can you find?”

Possible answers:

- FlowField calculation
- query per row
- external HTTP call
- page refresh
- doing all of it for records the user may never care about
This could be one of the best slides in the entire presentation.

## 17. Do less

### Slide 25 — The fastest code...

Large text:

**...is the code you don't execute.**

Examples:

- don't calculate invisible information
- don't load unnecessary page parts
- don't call external services unnecessarily
- don't repeatedly calculate stable values
- cache where appropriate
This maps directly to Microsoft's “do less” page performance guidance. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

## 18. Page Background Tasks

### Slide 26 — Render first, calculate second

Diagram:

```text
Open Page
   |
   +----> Essential information → NOW
   |
   +----> Statistics → background
   |
   +----> Recommendations → background
```

Examples:

- Role Center statistics
- KPIs
- additional contextual information
- expensive secondary calculations
Then reinforce:

**Performance is partly about protecting the UI thread.**

## 19. Web services and APIs

### Slide 27 — Don't expose UI as an API

Show:

```text
UI Page
├── triggers
├── FlowFields
├── FactBoxes
├── UI logic
└── presentation concerns
```

versus:

```text
API Page
├── deliberate payload
├── deliberate fields
└── integration contract
```

Microsoft specifically warns against using standard UI pages as web-service endpoints because page logic and calculated content can impose work that consumers don't need. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

## 20. HttpClient

### Slide 28 — Your performance depends on somebody else's server

```al
HttpClient.Get(Url, Response);
```

Then:

```text
Your AL
   ↓
Internet
   ↓
Vendor API
   ↓
?
```

Large:

**Your session is waiting.**

Discuss:

- timeouts
- slow APIs
- retries
- throttling
- failure
- whether the call belongs in an interactive flow
No deep integration architecture here.

## 21. 429, 503, 504

### Slide 29 — “Just retry” can make it worse

Show:

```text
429 Too Many Requests
503 Service Unavailable
504 Gateway Timeout
```

Then:

```text
Bad:
retry
retry
retry
retry
retry

Better:
retry
   ↓
backoff
   ↓
retry
```

Microsoft specifically recommends cooldown/retry strategies, including exponential backoff and queue-based smoothing for high-throughput integrations. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

## 22. Event subscribers

Now hit hidden costs.

### Slide 30 — You didn't call this code

Show:

```text
SalesHeader.Modify();
```

then visually explode it:

```text
SalesHeader.Modify()
       |
       +--> Subscriber A
       |
       +--> Subscriber B
       |
       +--> Subscriber C
       |
       +--> Subscriber D
```

Explain:

Performance reasoning gets harder in an event-driven architecture because the cost isn't always visible at the call site.

## 23. ModifyAll / DeleteAll surprise

### Slide 31 — Bulk... until it isn't

Show:

```al
Customer.ModifyAll(Blocked, Blocked::All);
```

Conceptually:

```text
Ideal

1 bulk SQL operation
```

Then:

```text
With certain event behavior

row
row
row
row
row
...
```

This is a very strong expert-level point.

Tell them:

“One subscriber can completely change the performance characteristics of code that looks beautifully set-based.”

Microsoft's performance guidance explicitly warns that test frameworks and subscribers can prevent bulk-mode behavior and cause operations to execute row by row. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

## 24. Locking

### Slide 32 — Fast alone. Slow together.

Put:

```text
Developer test:
1 user
```

✅ 300 ms

```text
Production:
100 users
```

🔥

Then introduce concurrency.

This transition works very well.

### Slide 33 — Transactions are shared time

Show:

```text
BEGIN TRANSACTION

read
calculate
external call
more calculation
write
LockTable
more work
write

COMMIT
```

Then:

“Which pieces really need to be inside this transaction?”

Explain:

- keep transactions as short as possible
- avoid unnecessary locks
- don't take locks too early
- don't hold database locks while doing unrelated work
## 25. LockTable

### Slide 34 — Lock late

Concept:

```text
Bad

LockTable
   ↓
10 seconds work
   ↓
Modify

Better

10 seconds preparation
   ↓
LockTable
   ↓
Modify
   ↓
Commit
```

The exact architecture varies, but the principle is very useful.

## 26. Tri-state locking

Because you're speaking to developers, I would include it, but briefly.

### Slide 35 — Modern BC locking

Introduce tri-state locking as a modern Business Central optimization for reducing unnecessary locking in read-after-write situations.

Don't spend five minutes explaining database isolation.

Make it a:

“Know that this exists, because the old mental model isn't always the full story anymore.”

This is the kind of slide that gives experienced developers something new.

## 27. OnCompanyOpen

### Slide 36 — Everybody pays for this

```al
[EventSubscriber(... OnCompanyOpen ...)]
local procedure CompanyOpen()
begin
    ...
end;
```

Then giant:

**EVERY SESSION**

Examples of things that should make you nervous:

- external HTTP request
- large SQL query
- expensive initialization
- scanning setup tables repeatedly
Phrase:

“If it takes two seconds here, you've just added two seconds to everybody's morning.”

## 28. Profiling

Now return to the opening promise.

### Slide 37 — Back to Rule #1

**Measure. Don't guess.**

Launch the AL Profiler.

A live demo is far better than screenshots.

Microsoft's AL Profiler supports both instrumentation and sampling. Instrumentation provides detailed timing and call counts; sampling offers lower-overhead investigation, and current versions can also surface SQL-call activity. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-profiler-overview))

## Demo 2 — Profile the bad code

Run your earlier deliberately inefficient process.

Show the profiler.

Walk the audience through only four things:

- total time
- expensive method
- number of calls
- SQL activity
Don't teach the profiler UI exhaustively.

Say:

“I'm not interested in everything this tool can tell me. I'm looking for the expensive shape of the problem.”

## 29. Sampling vs instrumentation

### Slide 38 — Which profiler?

Simple comparison:

| Sampling | Instrumentation |
| --- | --- |
| Low overhead | More detailed |
| Quickly locate hotspots | Exact method timings |
| Good first investigation | Good deep analysis |
| Performance trends | Call counts/details |

Microsoft describes sampling as faster and less noisy, while instrumentation provides greater accuracy and detail. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-profiler-overview))

## 30. A very current bonus: SQL calls in profiling

Because your session would likely run in late 2026, this is worth highlighting.

From Business Central 2025 release wave 2 onward, sampling profiling can track SQL calls, including through the in-client profiler. That helps developers distinguish expensive AL execution from SQL-driven delays. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-profiler-overview))

You can make this a strong moment:

“We don't have to infer whether AL or SQL is slow anymore. We can actually inspect the calls.”

## 31. Performance tests

### Slide 39 — “It seems faster” isn't a test

Huge:

**Before: 4.1 sec****After: 1.8 sec**

Still incomplete.

Ask:

“What changed?”

Then introduce measurable things:

- SQL statement count
- rows read
- runtime
- concurrent throughput
## 32. SessionInformation

### Slide 40 — Unit test your performance assumptions

Conceptual example:

```al
BeforeStatements := SessionInformation.SqlStatementsExecuted();
BeforeRows := SessionInformation.SqlRowsRead();

RunMyCode();

Statements :=
    SessionInformation.SqlStatementsExecuted()
    - BeforeStatements;

Rows :=
    SessionInformation.SqlRowsRead()
    - BeforeRows;
```

Then assertions.

The exact API syntax can be adjusted when building the final demo project, but the conceptual point is:

**Performance regressions can become failing tests.**

Microsoft explicitly recommends using SessionInformation to measure SQL statements and rows read before/after tested code. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

That's a fantastic take-home practice.

## 33. BC Performance Toolkit

### Slide 41 — Fast for me ≠ scalable

Introduce BCPT.

Show:

```text
Test user A ─┐
Test user B ─┤
Test user C ─┤
Test user D ─┼──> Business Central
Test user E ─┤
...
```

Ask:

“What happens when 50 people post sales orders at once?”

That is what BCPT helps investigate.

Microsoft describes BCPT as a tool for simulating realistic concurrent workloads and comparing performance between solution builds, especially to detect regressions as user volume grows. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-performance-toolkit))

## 34. Important BCPT nuance

One great fact to mention:

BCPT is designed to answer questions like:

“Can my solution support this mix of concurrent users?”

It is **not** designed to directly answer:

“How many orders per hour can Business Central process?”

Microsoft explicitly makes that distinction. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-performance-toolkit))

That's worth mentioning because developers often confuse load testing and throughput modelling.

## 35. Performance telemetry

I would mention but not demo.

### Slide 42 — When the problem only happens in production

Show:

```text
Development
   |
Profiler

Production
   |
Telemetry
```

Relevant telemetry categories include things such as:

- database locks
- long-running AL
- long-running SQL
- pages
- reports
- web service requests
- sessions
Microsoft lists those signals as key performance telemetry available through Application Insights. ([Microsoft Learn](https://learn.microsoft.com/pt-br/dynamics365/business-central/dev-itpro/performance/performance-developer))

Then say:

“Profiling tells you what happened while you're watching. Telemetry helps tell you what happened when you weren't.”

## 36. Reports

I would definitely keep reports, but use only one slide.

### Slide 43 — Reports have the same problems

Show:

```text
Report performance =
    data retrieval
  + calculations
  + layout
  + rendering
```

Developer-oriented optimizations include:

- partial records
- queries
- read scale-out where appropriate
- avoiding unnecessary dataset size
- choosing layout technology appropriately
- running reports in the background when responsiveness matters
Microsoft specifically recommends partial records, AL queries and Read Scale-Out as report-performance options, and notes that background execution changes perceived responsiveness rather than necessarily making the report itself execute faster. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-report-performance))

## 37. A future-looking bonus slide

Because this session will be current in 2026, I would add **one optional “what's new” slide**.

### Slide 44 — Performance profiling meets AI

Microsoft documents a Business Central 2026 release wave 2 capability where ALTool can expose scheduled performance profiling through MCP so an AI agent can investigate a slow Business Central session. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-tool))

Do not turn this into an AI session.

Just finish with something like:

“We're moving from:user says it's slow → developer profiles it

toward:user says it's slow → an agent can help collect and inspect the profile.”

That gives the session a fresh 2026 ending.

## Final section — the take-home rules

### Slide 45 — The Performance Ten Commandments

I wouldn't literally call them commandments; perhaps:

**10 Rules for Fast AL**

1. Measure before optimizing.
1. Think about SQL, not just AL.
1. Read only the records you need.
1. Load only the fields you need.
1. Prefer set-based work to record-by-record work.
1. Design keys for real access patterns.
1. Treat FlowFields as calculations, not fields.
1. Protect the UI thread.
1. Keep transactions and locks short.
1. Measure again.
Then reveal an eleventh:

**11. Never trust “it feels faster.”**

Good closing laugh.

## The running demo I recommend

This is important: I would **not** prepare ten unrelated demos.

Build **one Performance Lab extension**.

It contains a page such as:

```text
Performance Playground
```

with actions:

```al
1. Bad Customer Analysis
2. Partial Records
3. Set-Based Calculation
4. FlowField Optimization
5. Page Trigger Demo
6. Event Subscriber Demo
7. HttpClient Demo
8. Locking Demo
9. Profiler Demo
10. Performance Test
```

But during the session, you gradually improve the same scenario.

The story could be:

“Management wants a list of VIP customers showing outstanding balance, open-order value, number of open orders, and an external credit score.”

This is a fantastic performance case because it naturally creates almost every issue we want.

Naive implementation:

```al
Customer
   ↓
loop all customers
   ↓
CalcFields balance
   ↓
search Sales Header
   ↓
loop Sales Lines
   ↓
calculate amount
   ↓
HTTP credit-rating request
   ↓
render result
```

You can progressively optimize it.

## Demo progression

**Version 1 — Terrible**

- all fields loaded
- nested loops
- CalcFields inside loops
- HTTP per customer
- no useful keys
- all work in OnAfterGetRecord
Runtime:

```text
8.4 sec
```

You don't actually need exactly 8.4 seconds. Pick data volumes so there is a visible difference.

**Version 2 — Partial records**

Add:

```al
Customer.SetLoadFields(
    Customer."No.",
    Customer.Name);
```

Measure.

Maybe:

```text
8.4 sec → 7.2 sec
```

Message:

Partial records help, but we're still doing stupid things.

This is important. SetLoadFields should not look like a magic performance button.

**Version 3 — Remove nested iteration**

Replace loops with set-based calculations.

Maybe:

```text
7.2 sec → 2.8 sec
```

Now the audience sees the big performance gain.

**Version 4 — Fix indexes**

Run again:

```text
2.8 sec → 1.5 sec
```

Then inspect SQL calls.

**Version 5 — Handle FlowFields intelligently**

Maybe:

```text
1.5 sec → 900 ms
```

**Version 6 — External call leaves UI path**

Move the credit check to asynchronous/background processing.

Now:

```text
Page visible in 250 ms
```

This lets you make an important point:

```text
Backend calculation: perhaps still 800 ms
User-perceived response: 250 ms
```

That is a sophisticated performance lesson.

## A recurring measurement slide

After every demo optimization, show the same scoreboard:

| Version | Duration | SQL calls | Rows read |
| --- | --- | --- | --- |
| Original | 8.4 s | 2,104 | 187,442 |
| Partial records | 7.2 s | 2,104 | 187,442 |
| Set-based | 2.8 s | 304 | 32,112 |
| Keys | 1.5 s | 304 | 4,806 |
| FlowFields | 0.9 s | 104 | 4,806 |
| Async UI | 0.25 s perceived | — | — |

These numbers are placeholders until we build the actual demo.

The **scoreboard** is crucial because it makes performance tangible.

By the end the audience has visually watched:

```text
8.4 sec
 ↓
7.2 sec
 ↓
2.8 sec
 ↓
1.5 sec
 ↓
0.9 sec
```

That is much stronger than showing separate performance tips.

## Audience interaction

I'd deliberately insert about five questions.

At the start:

“Customer says BC is slow. What's your first move?”

For SetLoadFields:

“How many fields does this code need?”

For FlowFields:

“Is a FlowField a field?”

For page triggers:

“How many performance crimes are hiding in this trigger?”

For locking:

“Why was this perfectly fast when I tested it?”

These give you audience participation without needing polls or tools.

## Things I would deliberately NOT go deep on

There are several useful Microsoft topics that deserve acknowledgment but not teaching time.

I'd keep these in an appendix:

- Power BI/query folding
- detailed OData optimization
- Read Scale-Out configuration
- deep SIFT internals
- index internals
- detailed telemetry/KQL
- BCPT configuration walkthrough
- Visual Studio Code performance tuning
- report-layout tuning
- Media vs Blob
- Dictionary micro-benchmarks
- service-tier configuration
- SaaS resource allocation
Otherwise a one-hour developer session becomes four hours.

## One important change from my previous proposal

After checking the current documentation, I'd give the **Profiler more prominence**.

Starting with Business Central 2025 release wave 2, sampling profiling can expose SQL activity, which makes the profiler significantly more useful for the exact story we're telling: **AL code → SQL consequences**. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-profiler-overview))

And because Microsoft is introducing agent-assisted profiling through ALTool/MCP in **Business Central 2026 release wave 2**, there's a nice future-facing connection too. ([Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-tool))

So I'd make **profiling part of the story throughout the session**, not merely a tool shown at the end.

The narrative then becomes:

```text
      MEASURE
         ↓
   UNDERSTAND
         ↓
     CHANGE
         ↓
      MEASURE
         ↓
   DID IT IMPROVE?
```

↙       ↘

```text
    NO        YES
    ↓          ↓
 investigate  protect
              with test
```

That, to me, is the session.

The next useful step would be to turn this into the **actual presentation content**: slide-by-slide titles, what appears visually on each slide, exact speaker notes, and the AL code for the Performance Lab demo. That would give us everything needed to build the PowerPoint afterward.
