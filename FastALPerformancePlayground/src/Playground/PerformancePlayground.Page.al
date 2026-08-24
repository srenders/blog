page 70201 "Performance Playground"
{
    PageType = Card;
    Caption = 'Fast AL - Performance Playground';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Instructions)
            {
                Caption = 'Session workflow';
                field(Guidance; GuidanceText)
                {
                    ApplicationArea = All;
                    Caption = 'How to use';
                    ToolTip = 'Shows the measurement workflow for the demonstrations.';
                    MultiLine = true;
                    Editable = false;
                }
                field(DataSetSize; DataSetSize)
                {
                    ApplicationArea = All;
                    Caption = 'Entries to generate';
                    ToolTip = 'Sets the number of deterministic playground records to generate.';
                }
                field(BackgroundResult; BackgroundResultText)
                {
                    ApplicationArea = All;
                    Caption = 'Background task result';
                    ToolTip = 'Shows the latest result returned by the asynchronous demo.';
                    Editable = false;
                }
                field(HttpDemoUrl; HttpDemoUrl)
                {
                    ApplicationArea = All;
                    Caption = 'HTTP demo URL';
                    ToolTip = 'Optional URL used by the synchronous HttpClient demonstration. Leave empty during normal use.';
                }
            }
            part(Results; "Perf Demo Results")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Data)
            {
                Caption = '0. Prepare';
                action(GenerateData)
                {
                    ApplicationArea = All;
                    Caption = 'Generate demo entries';
                    ToolTip = 'Replaces the playground workload with the configured number of deterministic demo entries.';
                    trigger OnAction()
                    var
                        Generator: Codeunit "Perf Data Generator";
                    begin
                        Generator.GenerateEntries(DataSetSize);
                        Message('%1 demo entries generated.', DataSetSize);
                    end;
                }
                action(ClearData)
                {
                    ApplicationArea = All;
                    Caption = 'Clear demo entries';
                    ToolTip = 'Deletes only records from the playground demo table.';
                    trigger OnAction()
                    var
                        Generator: Codeunit "Perf Data Generator";
                    begin
                        if Confirm('Delete all playground demo entries?', false) then begin
                            Generator.ClearEntries();
                            Message('Playground demo entries cleared.');
                        end;
                    end;
                }
                action(ClearResults)
                {
                    ApplicationArea = All;
                    Caption = 'Clear measurements';
                    ToolTip = 'Deletes stored playground measurement results.';
                    trigger OnAction()
                    var
                        Measurement: Codeunit "Perf Measurement";
                    begin
                        Measurement.ClearResults();
                        CurrPage.Results.Page.Update(false);
                    end;
                }
            }
            group(DataAccess)
            {
                Caption = '1. Data access';
                action(FullRecord)
                {
                    ApplicationArea = All;
                    Caption = 'Full record read';
                    ToolTip = 'Runs the deliberately inefficient complete-record baseline.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunFullRecordRead();
                        RefreshResults();
                    end;
                }
                action(PartialRecord)
                {
                    ApplicationArea = All;
                    Caption = 'SetLoadFields';
                    ToolTip = 'Runs the partial-record implementation using SetLoadFields.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunPartialRecordRead();
                        RefreshResults();
                    end;
                }
                action(JitLoad)
                {
                    ApplicationArea = All;
                    Caption = 'JIT load trap';
                    ToolTip = 'Runs the partial-record example that accesses an unloaded field.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunJitLoadDemo();
                        RefreshResults();
                    end;
                }
                action(FindFirst)
                {
                    ApplicationArea = All;
                    Caption = 'FindFirst';
                    ToolTip = 'Runs the example for requesting one matching record.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunFindFirst();
                        RefreshResults();
                    end;
                }
                action(FindSetOne)
                {
                    ApplicationArea = All;
                    Caption = 'FindSet, consume one';
                    ToolTip = 'Runs the contrasting example where FindSet is used but one row is consumed.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunFindSetButOnlyOne();
                        RefreshResults();
                    end;
                }
                action(GetByPrimaryKey)
                {
                    ApplicationArea = All;
                    Caption = 'Get by primary key';
                    ToolTip = 'Runs Get when the primary key is known.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunGetByPrimaryKey();
                        RefreshResults();
                    end;
                }
                action(IndexedFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Indexed filters';
                    ToolTip = 'Runs filters aligned with the Category and Posting Date key.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunIndexedFilter();
                        RefreshResults();
                    end;
                }
            }
            group(SetBased)
            {
                Caption = '2. Set-based + FlowFields';
                action(LoopSum)
                {
                    ApplicationArea = All;
                    Caption = 'Loop SUM';
                    ToolTip = 'Runs the row-by-row AL aggregation baseline.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunLoopSum();
                        RefreshResults();
                    end;
                }
                action(CalcSums)
                {
                    ApplicationArea = All;
                    Caption = 'CalcSums';
                    ToolTip = 'Runs the database-side aggregate implementation.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunCalcSums();
                        RefreshResults();
                    end;
                }
                action(CalcFieldsLoop)
                {
                    ApplicationArea = All;
                    Caption = 'CalcFields in loop';
                    ToolTip = 'Calculates a FlowField separately for each record.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunCalcFieldsPerCustomer();
                        RefreshResults();
                    end;
                }
                action(AutoCalcFields)
                {
                    ApplicationArea = All;
                    Caption = 'SetAutoCalcFields';
                    ToolTip = 'Loads the FlowField as part of the record set.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunSetAutoCalcFields();
                        RefreshResults();
                    end;
                }
            }
            group(ALPatterns)
            {
                Caption = '3. AL patterns';
                action(TextConcat)
                {
                    ApplicationArea = All;
                    Caption = 'Text concatenation';
                    ToolTip = 'Runs repeated text concatenation in a substantial loop.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunTextConcatenation(10000);
                        RefreshResults();
                    end;
                }
                action(TextBuilder)
                {
                    ApplicationArea = All;
                    Caption = 'TextBuilder';
                    ToolTip = 'Runs the TextBuilder alternative for repeated appends.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunTextBuilder(10000);
                        RefreshResults();
                    end;
                }
                action(TempLookup)
                {
                    ApplicationArea = All;
                    Caption = 'Temporary table lookup';
                    ToolTip = 'Runs an in-memory lookup using a temporary record.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunTemporaryTableLookup(10000);
                        RefreshResults();
                    end;
                }
                action(DictionaryLookup)
                {
                    ApplicationArea = All;
                    Caption = 'Dictionary lookup';
                    ToolTip = 'Runs an in-memory key/value lookup using Dictionary.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunDictionaryLookup(10000);
                        RefreshResults();
                    end;
                }
            }
            group(HiddenCosts)
            {
                Caption = '4. Hidden costs';
                action(ModifyAll)
                {
                    ApplicationArea = All;
                    Caption = 'ModifyAll demo';
                    ToolTip = 'Runs ModifyAll with the optional deliberately expensive subscriber.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunModifyAll();
                        RefreshResults();
                    end;
                }
                action(EnableSubscriber)
                {
                    ApplicationArea = All;
                    Caption = 'Enable slow subscriber';
                    ToolTip = 'Enables the subscriber used to demonstrate hidden event-driven work.';
                    trigger OnAction()
                    var
                        Demos: Codeunit "Perf Event Demos";
                    begin
                        Demos.SetSubscriberEnabled(true);
                        Message('Slow subscriber enabled for this service instance.');
                    end;
                }
                action(DisableSubscriber)
                {
                    ApplicationArea = All;
                    Caption = 'Disable slow subscriber';
                    ToolTip = 'Disables the subscriber so the ModifyAll baseline can be measured.';
                    trigger OnAction()
                    var
                        Demos: Codeunit "Perf Event Demos";
                    begin
                        Demos.SetSubscriberEnabled(false);
                        Message('Slow subscriber disabled.');
                    end;
                }
                action(LockEarly)
                {
                    ApplicationArea = All;
                    Caption = 'Lock early';
                    ToolTip = 'Runs the locking example that takes the lock before preparation.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunLockEarly(1);
                        RefreshResults();
                    end;
                }
                action(LockLate)
                {
                    ApplicationArea = All;
                    Caption = 'Lock late';
                    ToolTip = 'Runs the locking example that delays the lock until needed.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunLockLate(1);
                        RefreshResults();
                    end;
                }
            }
            group(Async)
            {
                Caption = '5. Responsive UI';
                action(StartBackgroundTask)
                {
                    ApplicationArea = All;
                    Caption = 'Run page background task';
                    ToolTip = 'Starts the asynchronous calculation so the page can remain responsive.';
                    trigger OnAction()
                    var
                        Parameters: Dictionary of [Text, Text];
                    begin
                        CurrPage.EnqueueBackgroundTask(BackgroundTaskId, Codeunit::"Perf Background Task", Parameters, 60000, PageBackgroundTaskErrorLevel::Error);
                        BackgroundResultText := 'Background task started. Keep using the page.';
                        CurrPage.Update(false);
                    end;
                }
            }
            group(PagePerformance)
            {
                Caption = '6. Page performance';
                action(PagePerformanceBad)
                {
                    ApplicationArea = All;
                    Caption = 'Open bad page performance demo';
                    ToolTip = 'Opens a list page with deliberately expensive OnAfterGetRecord work.';
                    RunObject = page "Perf Page Performance Bad";
                }
                action(PagePerformanceGood)
                {
                    ApplicationArea = All;
                    Caption = 'Open good page performance demo';
                    ToolTip = 'Opens the list page without extra per-record trigger work.';
                    RunObject = page "Perf Page Performance Good";
                }
            }
            group(ReportPatterns)
            {
                Caption = '7. Report patterns';
                action(ReportNested)
                {
                    ApplicationArea = All;
                    Caption = 'Report: nested loops';
                    ToolTip = 'Simulates report dataset generation with nested Customer and PerfDemoEntry loops.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunReportNestedLoops();
                        RefreshResults();
                    end;
                }
                action(ReportOptimized)
                {
                    ApplicationArea = All;
                    Caption = 'Report: partial records';
                    ToolTip = 'Simulates optimized report dataset generation with partial records and efficient filtering.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        Runner.RunReportPartialRecords();
                        RefreshResults();
                    end;
                }
            }
            group(OptionalTopics)
            {
                Caption = '8. Optional platform topics';
                action(SynchronousHttp)
                {
                    ApplicationArea = All;
                    Caption = 'Run synchronous HttpClient demo';
                    ToolTip = 'Calls the configured URL synchronously and records the blocking request.';
                    trigger OnAction()
                    var
                        Runner: Codeunit "Perf Demo Runner";
                    begin
                        if HttpDemoUrl = '' then
                            Error('Enter an HTTP demo URL before running this optional demonstration.');
                        Runner.RunSynchronousHttpRequest(HttpDemoUrl);
                        RefreshResults();
                    end;
                }
                action(EnableCompanyOpenTeaching)
                {
                    ApplicationArea = All;
                    Caption = 'Enable company-open teaching flag';
                    ToolTip = 'Marks the presentation-only company-open example as enabled without subscribing to an event.';
                    trigger OnAction()
                    var
                        Demo: Codeunit "Perf Company Open Demo";
                    begin
                        Demo.EnableTeachingExample();
                        Message('Teaching flag enabled. No company-open subscriber is executed.');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        DataSetSize := 25000;
        GuidanceText := '1) Generate demo data.  2) Run a baseline and its optimized version.  3) Compare Duration, SQL Statements, and Rows Read.  4) Repeat after clearing results if cache effects matter.';
    end;

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; TaskResults: Dictionary of [Text, Text])
    var
        TotalBalanceText: Text;
        CompletedAtText: Text;
    begin
        if TaskId <> BackgroundTaskId then
            exit;
        TaskResults.Get('TotalBalance', TotalBalanceText);
        TaskResults.Get('CompletedAt', CompletedAtText);
        BackgroundResultText := CopyStr(StrSubstNo(BackgroundResultLbl, TotalBalanceText, CompletedAtText), 1, MaxStrLen(BackgroundResultText));
    end;

    trigger OnPageBackgroundTaskError(TaskId: Integer; ErrorCode: Text; ErrorText: Text; ErrorCallStack: Text; var IsHandled: Boolean)
    begin
        if TaskId <> BackgroundTaskId then
            exit;
        BackgroundResultText := CopyStr(StrSubstNo(BackgroundErrorLbl, ErrorText), 1, MaxStrLen(BackgroundResultText));
        IsHandled := true;
    end;

    local procedure RefreshResults()
    begin
        CurrPage.Results.Page.Update(false);
    end;

    var
        GuidanceText: Text[500];
        BackgroundResultText: Text[250];
        BackgroundTaskId: Integer;
        DataSetSize: Integer;
        HttpDemoUrl: Text[250];
        BackgroundResultLbl: Label 'Total customer balance: %1. Completed: %2', Comment = '%1 is the total balance returned by the background session; %2 is its completion timestamp.';
        BackgroundErrorLbl: Label 'Background task failed: %1', Comment = '%1 is the error returned by the child session.';
}
