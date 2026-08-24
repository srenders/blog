codeunit 70208 "Perf Demo Runner"
{
    procedure RunFullRecordRead()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('01 FULL RECORD', 'Bad_FullRecordRead', StartTime, StartSql, StartRows,
            Demos.Bad_FullRecordRead(), 'Baseline: no SetLoadFields.');
    end;

    procedure RunPartialRecordRead()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('02 PARTIAL', 'Good_PartialRecordRead', StartTime, StartSql, StartRows,
            Demos.Good_PartialRecordRead(), 'SetLoadFields loads only Amount.');
    end;

    procedure RunJitLoadDemo()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('03 JIT LOAD', 'Bad_JitLoadTrap', StartTime, StartSql, StartRows,
            Demos.Bad_JitLoadTrap(), 'Description was not loaded and may trigger a JIT load.');
    end;

    procedure RunLoopSum()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('04 LOOP SUM', 'Bad_LoopSum', StartTime, StartSql, StartRows,
            Demos.Bad_LoopSum(), 'AL iterates every matching row.');
    end;

    procedure RunCalcSums()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('05 CALCSUMS', 'Good_CalcSums', StartTime, StartSql, StartRows,
            Demos.Good_CalcSums(), 'Database-side aggregate using the SIFT key.');
    end;

    procedure RunFindFirst()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('06 FINDFIRST', 'Good_FindFirst', StartTime, StartSql, StartRows,
            Demos.Good_FindFirst(), 'Use FindFirst when one matching record is required.');
    end;

    procedure RunFindSetButOnlyOne()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('07 FINDSET ONE', 'Bad_FindSetForOne', StartTime, StartSql, StartRows,
            Demos.Bad_FindSetForOne(), 'FindSet expresses iteration, but only one row is consumed.');
    end;

    procedure RunCalcFieldsPerCustomer()
    var
        Demos: Codeunit "Perf FlowField Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('08 CALCFIELDS', 'Bad_CalcFieldsInLoop', StartTime, StartSql, StartRows,
            Demos.Bad_CalcFieldsInLoop(), 'CalcFields is deliberately called inside the loop.');
    end;

    procedure RunSetAutoCalcFields()
    var
        Demos: Codeunit "Perf FlowField Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('09 AUTO CALC', 'Good_SetAutoCalcFields', StartTime, StartSql, StartRows,
            Demos.Good_SetAutoCalcFields(), 'SetAutoCalcFields includes the FlowField in retrieval.');
    end;

    procedure RunTextConcatenation(Iterations: Integer)
    var
        Demos: Codeunit "Perf AL Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('10 TEXT CONCAT', 'Bad_TextConcatenation', StartTime, StartSql, StartRows,
            Demos.Bad_TextConcatenation(Iterations), 'Repeated concatenation is the deliberate baseline.');
    end;

    procedure RunTextBuilder(Iterations: Integer)
    var
        Demos: Codeunit "Perf AL Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('11 TEXTBUILDER', 'Good_TextBuilder', StartTime, StartSql, StartRows,
            Demos.Good_TextBuilder(Iterations), 'TextBuilder is used for repeated appends.');
    end;

    procedure RunTemporaryTableLookup(Iterations: Integer)
    var
        Demos: Codeunit "Perf AL Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('12 TEMP LOOKUP', 'Bad_TemporaryRecordLookup', StartTime, StartSql, StartRows,
            Demos.Bad_TemporaryRecordLookup(Iterations), 'A temporary record is database-shaped.');
    end;

    procedure RunDictionaryLookup(Iterations: Integer)
    var
        Demos: Codeunit "Perf AL Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('13 DICTIONARY', 'Good_DictionaryLookup', StartTime, StartSql, StartRows,
            Demos.Good_DictionaryLookup(Iterations), 'Dictionary expresses an in-memory key/value lookup.');
    end;

    procedure RunLockEarly(DemoEntryNo: Integer)
    var
        Demos: Codeunit "Perf Locking Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('15 LOCK EARLY', 'Bad_LockEarly', StartTime, StartSql, StartRows,
            Demos.Bad_LockEarly(DemoEntryNo), 'The lock is taken before unrelated preparation work.');
    end;

    procedure RunLockLate(DemoEntryNo: Integer)
    var
        Demos: Codeunit "Perf Locking Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('16 LOCK LATE', 'Good_LockLate', StartTime, StartSql, StartRows,
            Demos.Good_LockLate(DemoEntryNo), 'Preparation is completed before taking the lock.');
    end;

    procedure RunModifyAll()
    var
        Demos: Codeunit "Perf Event Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('14 MODIFYALL', 'Bad_ModifyAllWithHiddenSubscriber', StartTime, StartSql, StartRows,
            Demos.Bad_ModifyAllWithHiddenSubscriber(), 'Use the subscriber toggle to expose hidden event work.');
    end;

    procedure RunSynchronousHttpRequest(Url: Text)
    var
        Demos: Codeunit "Perf HttpClient Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('17 HTTP CLIENT', 'Bad_SynchronousHttpRequest', StartTime, StartSql, StartRows,
            Demos.Bad_SynchronousHttpRequest(Url), 'Synchronous HTTP blocks the current AL session while waiting.');
    end;

    procedure RunGetByPrimaryKey()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('18 GET', 'Good_GetByPrimaryKey', StartTime, StartSql, StartRows,
            Demos.Good_GetByPrimaryKey(), 'Get expresses lookup by known primary key.');
    end;

    procedure RunIndexedFilter()
    var
        Demos: Codeunit "Perf Data Access Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('19 INDEXED FILTER', 'Good_IndexedFilter', StartTime, StartSql, StartRows,
            Demos.Good_IndexedFilter(), 'Category and Posting Date filters align with the demo key.');
    end;

    procedure RunReportNestedLoops()
    var
        Demos: Codeunit "Perf Report Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('17 REPORT NESTED', 'Bad_ReportNestedLoops', StartTime, StartSql, StartRows,
            Demos.Bad_ReportNestedLoops(), 'Nested Customer loop with per-record PerfDemoEntry queries and CalcFields.');
    end;

    procedure RunReportPartialRecords()
    var
        Demos: Codeunit "Perf Report Demos";
        Measurement: Codeunit "Perf Measurement";
        StartTime: DateTime;
        StartSql: BigInteger;
        StartRows: BigInteger;
    begin
        Measurement.Start(StartTime, StartSql, StartRows);
        Measurement.Finish('18 REPORT OPTIMIZED', 'Good_ReportPartialRecords', StartTime, StartSql, StartRows,
            Demos.Good_ReportPartialRecords(), 'Partial records with SetAutoCalcFields and indexed filtering.');
    end;
}