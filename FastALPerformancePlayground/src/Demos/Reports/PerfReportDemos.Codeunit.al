codeunit 70212 "Perf Report Demos"
{
    procedure Bad_ReportNestedLoops(): Integer
    var
        PerfReportNestedLoops: Report "Perf Report Nested Loops";
    begin
        // DEMO: Run actual report with nested dataitem pattern.
        PerfReportNestedLoops.Run();
        exit(PerfReportNestedLoops.GetCustomerCount());
    end;

    procedure Good_ReportPartialRecords(): Integer
    var
        PerfReportPartialRecords: Report "Perf Report Partial Records";
    begin
        // DEMO: Run actual report with optimized data retrieval.
        PerfReportPartialRecords.Run();
        exit(PerfReportPartialRecords.GetCustomerCount());
    end;
}
