codeunit 70200 "Perf Measurement"
{
    procedure Start(var StartTime: DateTime; var StartSqlStatements: BigInteger; var StartRowsRead: BigInteger)
    begin
        StartTime := CurrentDateTime();
        StartSqlStatements := SessionInformation.SqlStatementsExecuted();
        StartRowsRead := SessionInformation.SqlRowsRead();
    end;

    procedure Finish(DemoCode: Code[30]; Description: Text[100]; StartTime: DateTime; StartSqlStatements: BigInteger; StartRowsRead: BigInteger; ResultValue: Decimal; Notes: Text[250])
    var
        PerfDemoResult: Record "Perf Demo Result";
        DurationValue: Duration;
        SqlStatements: BigInteger;
        RowsRead: BigInteger;
        NextRunNo: Integer;
    begin
        DurationValue := CurrentDateTime() - StartTime;
        SqlStatements := SessionInformation.SqlStatementsExecuted() - StartSqlStatements;
        RowsRead := SessionInformation.SqlRowsRead() - StartRowsRead;

        PerfDemoResult.SetRange("Demo Code", DemoCode);
        if PerfDemoResult.FindLast() then
            NextRunNo := PerfDemoResult."Run No." + 1
        else
            NextRunNo := 1;

        PerfDemoResult.Init();
        PerfDemoResult."Demo Code" := DemoCode;
        PerfDemoResult."Run No." := NextRunNo;
        PerfDemoResult.Insert();

        PerfDemoResult.Description := Description;
        PerfDemoResult.Duration := DurationValue;
        PerfDemoResult."SQL Statements" := SqlStatements;
        PerfDemoResult."Rows Read" := RowsRead;
        PerfDemoResult."Result Value" := ResultValue;
        PerfDemoResult."Last Run At" := CurrentDateTime();
        PerfDemoResult.Notes := Notes;
        PerfDemoResult.Modify();
    end;

    procedure ClearResults()
    var
        PerfDemoResult: Record "Perf Demo Result";
    begin
        PerfDemoResult.DeleteAll();
    end;
}
