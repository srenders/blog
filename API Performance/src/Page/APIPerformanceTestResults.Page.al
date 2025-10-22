page 91119 "API Performance Test Results"
{
    Caption = 'API Performance Test Results';
    PageType = List;
    SourceTable = "API Performance Test Results";
    UsageCategory = History;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Test Run No."; Rec."Test Run No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Test run number for grouping related tests.';
                }

                field("Test Run DateTime"; Rec."Test Run DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'When the test was executed.';
                }

                field("Test Type"; Rec."Test Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of performance test executed.';
                }

                field("API Name"; GetAPIName())
                {
                    ApplicationArea = All;
                    Caption = 'API Tested';
                    ToolTip = 'Name of the API that was tested.';
                    Style = Attention;
                    StyleExpr = true;
                }

                field("Table Variant"; Rec."Table Variant")
                {
                    ApplicationArea = All;
                    ToolTip = 'Which table variant was tested.';
                }

                field("API Type"; Rec."API Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of API tested (Page or Query).';
                }

                field("Duration (ms)"; Rec."Duration (ms)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Duration in milliseconds.';
                    Style = Strong;
                    StyleExpr = true;
                }

                field("Record Count"; Rec."Record Count")
                {
                    ApplicationArea = All;
                    Caption = 'Records Retrieved';
                    ToolTip = 'Number of records read during the test.';
                    Style = Favorable;
                    StyleExpr = true;
                }

                field("Test Description"; Rec."Test Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of what was tested.';
                }

                field("Filter Applied"; Rec."Filter Applied")
                {
                    ApplicationArea = All;
                    ToolTip = 'Filter that was applied during the test.';
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Actions';

                actionref(DeleteAll_Promoted; DeleteAllResults) { }
                actionref(DeleteOld_Promoted; DeleteOldResults) { }
            }

            group(Category_Report)
            {
                Caption = 'Analysis';

                actionref(ShowLatest_Promoted; ShowLatestTestRun) { }
                actionref(ShowBestPerformer_Promoted; ShowBestPerformer) { }
                actionref(CompareLatest_Promoted; CompareLatestRuns) { }
                actionref(ShowStatistics_Promoted; ShowStatistics) { }
                actionref(ClearFilters_Promoted; ClearAllFilters) { }
            }
        }

        area(processing)
        {
            action(ShowLatestTestRun)
            {
                Caption = 'Show Latest Test Run';
                ApplicationArea = All;
                Image = FilterLines;
                ToolTip = 'Filter to show only the most recent test execution.';

                trigger OnAction()
                var
                    APIPerformanceTestResults: Record "API Performance Test Results";
                    LatestTestRunNo: Integer;
                begin
                    APIPerformanceTestResults.SetCurrentKey("Test Run No.");
                    if APIPerformanceTestResults.FindLast() then begin
                        LatestTestRunNo := APIPerformanceTestResults."Test Run No.";
                        Rec.SetRange("Test Run No.", LatestTestRunNo);
                        CurrPage.Update(false);
                        Message('Showing Test Run #%1', LatestTestRunNo);
                    end else
                        Message('No test results found.');
                end;
            }

            action(ShowBestPerformer)
            {
                Caption = 'Show Best Performing APIs';
                ApplicationArea = All;
                Image = Forecast;
                ToolTip = 'Analyze all test results and show which API combinations perform best.';

                trigger OnAction()
                begin
                    ShowBestPerformingAPIs();
                end;
            }

            action(ClearAllFilters)
            {
                Caption = 'Clear All Filters';
                ApplicationArea = All;
                Image = ClearFilter;
                ToolTip = 'Remove all filters to show all test results.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetCurrentKey("Entry No.");
                    Rec.Ascending(false);
                    CurrPage.Update(false);
                end;
            }

            action(DeleteAllResults)
            {
                Caption = 'Delete All Test Results';
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Delete all performance test results from the history.';

                trigger OnAction()
                var
                    APIPerformanceTestResults: Record "API Performance Test Results";
                begin
                    if Confirm('Delete all test results?', false) then begin
                        APIPerformanceTestResults.DeleteAll();
                        CurrPage.Update(false);
                    end;
                end;
            }

            action(DeleteOldResults)
            {
                Caption = 'Delete Results Older Than 30 Days';
                ApplicationArea = All;
                Image = ClearFilter;
                ToolTip = 'Delete test results older than 30 days.';

                trigger OnAction()
                var
                    APIPerformanceTestResults: Record "API Performance Test Results";
                begin
                    APIPerformanceTestResults.SetFilter("Test Run DateTime", '<%1', CreateDateTime(CalcDate('<-30D>', Today), 0T));
                    if not APIPerformanceTestResults.IsEmpty then
                        if Confirm('Delete %1 test results older than 30 days?', false, APIPerformanceTestResults.Count) then begin
                            APIPerformanceTestResults.DeleteAll();
                            CurrPage.Update(false);
                        end;
                end;
            }

            action(CompareLatestRuns)
            {
                Caption = 'Compare Last 2 Test Runs';
                ApplicationArea = All;
                Image = CompareCOA;
                ToolTip = 'Compare the last 2 test runs and show performance differences.';

                trigger OnAction()
                begin
                    CompareLastTwoTestRuns();
                end;
            }

            action(ShowStatistics)
            {
                Caption = 'Show Statistics';
                ApplicationArea = All;
                Image = Statistics;
                ToolTip = 'Show average, min, max performance by table variant and API type.';

                trigger OnAction()
                begin
                    ShowPerformanceStatistics();
                end;
            }
        }
    }

    procedure ShowPerformanceStatistics()
    var
        APIPerformanceTestResults: Record "API Performance Test Results";
        StatisticsMsg: Text;
        TableVariantInt: Integer;
        APITypeInt: Integer;
        TotalDuration: Duration;
        RecCount: Integer;
        AvgDuration: Decimal;
        TableVariantEnum: Enum "Table Variant Type";
        APITypeEnum: Enum "API Type";
        StatLbl: Label '  %1: Avg %2 ms (%3 tests)\', Comment = '%1 = API Type, %2 = Average duration, %3 = Test count';
    begin
        StatisticsMsg := '=== Performance Statistics ===\\';

        for TableVariantInt := 1 to 4 do begin
            TableVariantEnum := Enum::"Table Variant Type".FromInteger(TableVariantInt);
            StatisticsMsg += StrSubstNo('%1:\\', Format(TableVariantEnum));

            for APITypeInt := 1 to 3 do begin
                APITypeEnum := Enum::"API Type".FromInteger(APITypeInt);

                APIPerformanceTestResults.Reset();
                APIPerformanceTestResults.SetRange("Table Variant", TableVariantEnum);
                APIPerformanceTestResults.SetRange("API Type", APITypeEnum);

                if APIPerformanceTestResults.FindSet() then begin
                    TotalDuration := 0;
                    RecCount := 0;

                    repeat
                        TotalDuration += APIPerformanceTestResults."Duration (ms)";
                        RecCount += 1;
                    until APIPerformanceTestResults.Next() = 0;

                    if RecCount > 0 then begin
                        AvgDuration := TotalDuration / RecCount;
                        StatisticsMsg += StrSubstNo(StatLbl,
                            Format(APITypeEnum), Round(AvgDuration, 1), RecCount);
                    end;
                end;
            end;

            StatisticsMsg += '\\';
        end;

        Message(StatisticsMsg);
    end;

    procedure CompareLastTwoTestRuns()
    var
        TestResults: Record "API Performance Test Results";
        TempTestRunNos: Record "Integer" temporary;
        Run1No, Run2No : Integer;
        Run1Results, Run2Results : array[4, 3] of Duration;  // [Variant, APIType]
        ComparisonMsg: Text;
        VariantInt, APITypeInt : Integer;
        VariantEnum: Enum "Table Variant Type";
        APITypeEnum: Enum "API Type";
        Difference: Duration;
        PercentChange: Decimal;
        CompLbl: Label '%1 - %2: Run #%3=%4ms, Run #%5=%6ms, Diff=%7ms (%8%)\', Comment = '%1=Variant, %2=API Type, %3=Run1 No, %4=Run1 ms, %5=Run2 No, %6=Run2 ms, %7=Diff, %8=Percent';
        CompHeaderLbl: Label '=== Comparing Test Run #%1 (newest) vs #%2 ===\\', Comment = '%1=Run1 No, %2=Run2 No';
        VariantHeaderLbl: Label '%1:\\', Comment = '%1=Variant name';
    begin
        // Get the last 2 unique Test Run Numbers
        TestResults.SetCurrentKey("Test Run No.");
        if TestResults.FindSet() then
            repeat
                TempTestRunNos.Number := TestResults."Test Run No.";
                if TempTestRunNos.Insert() then;
            until TestResults.Next() = 0;

        TempTestRunNos.SetCurrentKey(Number);
        TempTestRunNos.Ascending(false);
        if not TempTestRunNos.FindSet() then begin
            Message('Need at least 2 test runs to compare.');
            exit;
        end;
        Run1No := TempTestRunNos.Number;

        if TempTestRunNos.Next() = 0 then begin
            Message('Need at least 2 test runs to compare.');
            exit;
        end;
        Run2No := TempTestRunNos.Number;

        // Load results for both runs
        for VariantInt := 1 to 4 do begin
            VariantEnum := Enum::"Table Variant Type".FromInteger(VariantInt);
            for APITypeInt := 1 to 3 do begin
                APITypeEnum := Enum::"API Type".FromInteger(APITypeInt);

                // Get Run 1 result
                TestResults.Reset();
                TestResults.SetRange("Test Run No.", Run1No);
                TestResults.SetRange("Table Variant", VariantEnum);
                TestResults.SetRange("API Type", APITypeEnum);
                if TestResults.FindFirst() then
                    Run1Results[VariantInt, APITypeInt] := TestResults."Duration (ms)";

                // Get Run 2 result
                TestResults.Reset();
                TestResults.SetRange("Test Run No.", Run2No);
                TestResults.SetRange("Table Variant", VariantEnum);
                TestResults.SetRange("API Type", APITypeEnum);
                if TestResults.FindFirst() then
                    Run2Results[VariantInt, APITypeInt] := TestResults."Duration (ms)";
            end;
        end;

        // Build comparison message
        ComparisonMsg := StrSubstNo(CompHeaderLbl, Run1No, Run2No);

        for VariantInt := 1 to 4 do begin
            VariantEnum := Enum::"Table Variant Type".FromInteger(VariantInt);
            ComparisonMsg += StrSubstNo(VariantHeaderLbl, Format(VariantEnum));

            for APITypeInt := 1 to 3 do begin
                APITypeEnum := Enum::"API Type".FromInteger(APITypeInt);

                if (Run1Results[VariantInt, APITypeInt] > 0) and (Run2Results[VariantInt, APITypeInt] > 0) then begin
                    Difference := Run1Results[VariantInt, APITypeInt] - Run2Results[VariantInt, APITypeInt];
                    if Run2Results[VariantInt, APITypeInt] <> 0 then
                        PercentChange := (Difference / Run2Results[VariantInt, APITypeInt]) * 100
                    else
                        PercentChange := 0;

                    ComparisonMsg += StrSubstNo(CompLbl,
                        Format(VariantEnum), Format(APITypeEnum),
                        Run1No, Run1Results[VariantInt, APITypeInt],
                        Run2No, Run2Results[VariantInt, APITypeInt],
                        Difference, Round(PercentChange, 0.1));
                end;
            end;
            ComparisonMsg += '\\';
        end;

        ComparisonMsg += '\Negative difference = newer run is faster\Positive difference = newer run is slower';

        Message(ComparisonMsg);
    end;

    local procedure GetAPIName(): Text
    begin
        // Reuse BuildAPIName to avoid duplication
        exit(BuildAPIName(Rec."Table Variant", Rec."API Type"));
    end;

    procedure ShowBestPerformingAPIs()
    var
        TestResults: Record "API Performance Test Results";
        VariantInt, APITypeInt : Integer;
        VariantEnum: Enum "Table Variant Type";
        APITypeEnum: Enum "API Type";
        ResultMsg: Text;
        BestAPIName: Text;
        AvgDuration: Decimal;
        TestCount: Integer;
        TotalDuration: Duration;
        WinnerLbl: Label '🏆 %1: Avg %2ms (%3 tests)\', Comment = '%1=API Name, %2=Avg Duration, %3=Test Count';
        HeaderLbl: Label '=== Best Performing APIs (Lowest Average Duration) ===\\';
        CategoryLbl: Label '%1:\\', Comment = '%1=Category name';
    begin
        if TestResults.IsEmpty then begin
            Message('No test results available. Run some performance tests first.');
            exit;
        end;

        ResultMsg := HeaderLbl;

        // Find best performer for each variant
        for VariantInt := 1 to 4 do begin
            VariantEnum := Enum::"Table Variant Type".FromInteger(VariantInt);
            ResultMsg += StrSubstNo(CategoryLbl, Format(VariantEnum));

            // Compare Page API vs Query API vs Aggregate Query for this variant
            for APITypeInt := 1 to 3 do begin
                APITypeEnum := Enum::"API Type".FromInteger(APITypeInt);

                TestResults.Reset();
                TestResults.SetRange("Table Variant", VariantEnum);
                TestResults.SetRange("API Type", APITypeEnum);

                if TestResults.FindSet() then begin
                    TotalDuration := 0;
                    TestCount := 0;

                    repeat
                        TotalDuration += TestResults."Duration (ms)";
                        TestCount += 1;
                    until TestResults.Next() = 0;

                    if TestCount > 0 then begin
                        AvgDuration := TotalDuration / TestCount;

                        // Build API name for display
                        BestAPIName := BuildAPIName(VariantEnum, APITypeEnum);

                        ResultMsg += '  ' + BestAPIName + ': ' + Format(Round(AvgDuration, 1)) + 'ms (' + Format(TestCount) + ' tests)\';
                    end;
                end;
            end;

            ResultMsg += '\\';
        end;

        // Find overall best performer (lowest duration)
        TestResults.Reset();
        TestResults.SetCurrentKey("Duration (ms)");
        TestResults.Ascending(true);  // Lowest duration first
        if TestResults.FindFirst() then begin
            BestAPIName := BuildAPIName(TestResults."Table Variant", TestResults."API Type");
            ResultMsg += StrSubstNo(WinnerLbl, BestAPIName, TestResults."Duration (ms)", 1);
            ResultMsg += '\(Based on single fastest test execution)';
        end;

        Message(ResultMsg);
    end;

    procedure BuildAPIName(TableVariant: Enum "Table Variant Type"; APIType: Enum "API Type"): Text
    var
        APIName: Text;
    begin
        // Return exact EntitySetName from API definitions
        case TableVariant of
            TableVariant::Original:
                case APIType of
                    APIType::"Page API":
                        APIName := 'simpleTransactionEntriesPages';
                    APIType::"Query API":
                        APIName := 'simpleTransactionEntryQuerys';
                    APIType::"Aggregate Query":
                        APIName := 'simpleTransactionEntryQueryAggrs';
                end;
            TableVariant::"No Covering":
                case APIType of
                    APIType::"Page API":
                        APIName := 'simpleTransactionNoCovers';
                    APIType::"Query API":
                        APIName := 'simpleTransactionNoCoversQuery';
                    APIType::"Aggregate Query":
                        APIName := 'simpleTransactionNoCoversAggr';
                end;
            TableVariant::"Minimal Keys":
                case APIType of
                    APIType::"Page API":
                        APIName := 'simpleTransactionMinimal';
                    APIType::"Query API":
                        APIName := 'simpleTransactionMinimalQuery';
                    APIType::"Aggregate Query":
                        APIName := 'simpleTransactionMinimalAggr';
                end;
            TableVariant::"Alternative Covering":
                case APIType of
                    APIType::"Page API":
                        APIName := 'simpleTransactionAltCover';
                    APIType::"Query API":
                        APIName := 'simpleTransactionAltCoverQuery';
                    APIType::"Aggregate Query":
                        APIName := 'simpleTransactionAltCoverAggr';
                end;
        end;

        exit(APIName);
    end;
}