codeunit 91107 "API Performance Tester"
{
    /// <summary>
    /// Tests and measures READ performance for Page APIs vs Query APIs
    /// All tests are READ-ONLY operations to compare query performance
    /// </summary>

    var
        CurrentTestRunNo: Integer;


    /// <summary>
    /// Runs READ performance tests on all API variants and displays results
    /// Tests Page APIs (record-based) vs Query APIs (query-based) for read operations
    /// </summary>
    procedure RunAllPerformanceTests()
    begin
        CurrentTestRunNo := GetNextTestRunNo();

        // Test Original Table APIs
        TestTableVariant(1, 'Original (Covering Indexes)');

        // Test No Covering APIs
        TestTableVariant(2, 'No Covering Indexes)');

        // Test Minimal Keys APIs
        TestTableVariant(3, 'Minimal Keys');

        // Test Alternative Covering APIs
        TestTableVariant(4, 'Alternative Covering');

        // Results are saved to database - view in "API Performance Test Results" page
        Message('Performance tests completed. View results in "API Performance Test Results" page.');
    end;

    local procedure TestTableVariant(VariantNumber: Integer; VariantName: Text)
    var
        PageAPITime: Duration;
        QueryAPITime: Duration;
        AggrQueryAPITime: Duration;
        RecordCount: Integer;
        AggrRecordCount: Integer;
        TableVariant: Enum "Table Variant Type";
    begin
        // Convert variant number to enum
        TableVariant := "Table Variant Type".FromInteger(VariantNumber);

        // Test Page API - Reads records through table
        PageAPITime := MeasurePageAPIPerformance(VariantNumber, RecordCount);
        LogTestResult("Performance Test Type"::"All Tests", TableVariant, "API Type"::"Page API", PageAPITime, RecordCount, CopyStr(VariantName, 1, 250), '');

        // Test Query API - Reads records through query object
        QueryAPITime := MeasureQueryAPIPerformance(VariantNumber, RecordCount);
        LogTestResult("Performance Test Type"::"All Tests", TableVariant, "API Type"::"Query API", QueryAPITime, RecordCount, CopyStr(VariantName, 1, 250), '');

        // Test Aggregate Query API - Reads aggregated data
        AggrQueryAPITime := MeasureAggregateQueryAPIPerformance(VariantNumber, AggrRecordCount);
        LogTestResult("Performance Test Type"::"All Tests", TableVariant, "API Type"::"Aggregate Query", AggrQueryAPITime, AggrRecordCount, CopyStr(VariantName + ' - Aggregate', 1, 250), '');
    end;

    /// <summary>
    /// Measures READ performance of Page API (uses record table directly)
    /// Simulates Power BI reading ALL records from the API endpoint
    /// </summary>
    local procedure MeasurePageAPIPerformance(VariantNumber: Integer; var RecordCount: Integer): Duration
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
        SimpleTransNoCovers: Record "Simple Trans No Covers";
        SimpleTransMinimalKeys: Record "Simple Trans Minimal Keys";
        SimpleTransAltCovering: Record "Simple Trans Alt Covering";
        StartTime: DateTime;
        EndTime: DateTime;
    begin
        RecordCount := 0;
        StartTime := CurrentDateTime;

        case VariantNumber of
            1: // Original - Read ALL records
                if SimpleTransactionEntry.FindSet() then
                    repeat
                        RecordCount += 1;
                    until SimpleTransactionEntry.Next() = 0;
            2: // No Covering - Read ALL records
                if SimpleTransNoCovers.FindSet() then
                    repeat
                        RecordCount += 1;
                    until SimpleTransNoCovers.Next() = 0;
            3: // Minimal - Read ALL records
                if SimpleTransMinimalKeys.FindSet() then
                    repeat
                        RecordCount += 1;
                    until SimpleTransMinimalKeys.Next() = 0;
            4: // Alternative Covering - Read ALL records
                if SimpleTransAltCovering.FindSet() then
                    repeat
                        RecordCount += 1;
                    until SimpleTransAltCovering.Next() = 0;
        end;

        EndTime := CurrentDateTime;

        exit(EndTime - StartTime);
    end;

    /// <summary>
    /// Measures READ performance of Query API (uses query object)
    /// Simulates Power BI reading ALL records from the Query API endpoint
    /// </summary>
    local procedure MeasureQueryAPIPerformance(VariantNumber: Integer; var RecordCount: Integer): Duration
    var
        SimpleTransactionQuery: Query "Simple Transaction";
        SimpleTransNoCoversQuery: Query "Simple Trans No Covers";
        SimpleTransMinimalQuery: Query "Simple Trans Minimal";
        SimpleTransAltCoverQuery: Query "Simple Trans Alt Cover";
        StartTime: DateTime;
        EndTime: DateTime;
    begin
        RecordCount := 0;
        StartTime := CurrentDateTime;

        case VariantNumber of
            1: // Original - Read ALL records
                begin
                    SimpleTransactionQuery.Open();
                    while SimpleTransactionQuery.Read() do
                        RecordCount += 1;
                    SimpleTransactionQuery.Close();
                end;
            2: // No Covering - Read ALL records
                begin
                    SimpleTransNoCoversQuery.Open();
                    while SimpleTransNoCoversQuery.Read() do
                        RecordCount += 1;
                    SimpleTransNoCoversQuery.Close();
                end;
            3: // Minimal - Read ALL records
                begin
                    SimpleTransMinimalQuery.Open();
                    while SimpleTransMinimalQuery.Read() do
                        RecordCount += 1;
                    SimpleTransMinimalQuery.Close();
                end;
            4: // Alternative - Read ALL records
                begin
                    SimpleTransAltCoverQuery.Open();
                    while SimpleTransAltCoverQuery.Read() do
                        RecordCount += 1;
                    SimpleTransAltCoverQuery.Close();
                end;
        end;

        EndTime := CurrentDateTime;

        exit(EndTime - StartTime);
    end;

    /// <summary>
    /// Measures READ performance of Aggregate Query API (uses aggregated query object)
    /// Simulates Power BI reading aggregated data grouped by Customer, Document Type, Posting Date
    /// </summary>
    local procedure MeasureAggregateQueryAPIPerformance(VariantNumber: Integer; var RecordCount: Integer): Duration
    var
        SimpleTransactionAggrQuery: Query "Simple Transaction Aggr";
        SimpleTransNoCoversAggrQuery: Query "Simple Trans No Covers Aggr";
        SimpleTransMinimalAggrQuery: Query "Simple Trans Minimal Aggr";
        SimpleTransAltCoverAggrQuery: Query "Simple Trans Alt Cover Aggr";
        StartTime: DateTime;
        EndTime: DateTime;
    begin
        RecordCount := 0;
        StartTime := CurrentDateTime;

        case VariantNumber of
            1: // Original - Read ALL aggregated records
                begin
                    SimpleTransactionAggrQuery.Open();
                    while SimpleTransactionAggrQuery.Read() do
                        RecordCount += 1;
                    SimpleTransactionAggrQuery.Close();
                end;
            2: // No Covering - Read ALL aggregated records
                begin
                    SimpleTransNoCoversAggrQuery.Open();
                    while SimpleTransNoCoversAggrQuery.Read() do
                        RecordCount += 1;
                    SimpleTransNoCoversAggrQuery.Close();
                end;
            3: // Minimal - Read ALL aggregated records
                begin
                    SimpleTransMinimalAggrQuery.Open();
                    while SimpleTransMinimalAggrQuery.Read() do
                        RecordCount += 1;
                    SimpleTransMinimalAggrQuery.Close();
                end;
            4: // Alternative - Read ALL aggregated records
                begin
                    SimpleTransAltCoverAggrQuery.Open();
                    while SimpleTransAltCoverAggrQuery.Read() do
                        RecordCount += 1;
                    SimpleTransAltCoverAggrQuery.Close();
                end;
        end;

        EndTime := CurrentDateTime;

        exit(EndTime - StartTime);
    end;

    local procedure LogTestResult(TestType: Enum "Performance Test Type"; TableVariant: Enum "Table Variant Type"; APIType: Enum "API Type"; Duration: Duration; RecordCount: Integer; Description: Text[250]; FilterApplied: Text[250])
    var
        TestResult: Record "API Performance Test Results";
    begin
        TestResult.Init();
        TestResult."Test Run No." := CurrentTestRunNo;
        TestResult."Test Run DateTime" := CurrentDateTime;
        TestResult."Test Type" := TestType;
        TestResult."Table Variant" := TableVariant;
        TestResult."API Type" := APIType;
        TestResult."Duration (ms)" := Duration;
        TestResult."Record Count" := RecordCount;
        TestResult."Test Description" := CopyStr(Description, 1, MaxStrLen(TestResult."Test Description"));
        TestResult."Filter Applied" := CopyStr(FilterApplied, 1, MaxStrLen(TestResult."Filter Applied"));
        TestResult.Insert(true);
    end;

    local procedure GetNextTestRunNo(): Integer
    var
        TestResult: Record "API Performance Test Results";
    begin
        if TestResult.FindLast() then
            exit(TestResult."Test Run No." + 1)
        else
            exit(1);
    end;
}
