codeunit 70206 "Perf Locking Demos"
{
    procedure Bad_LockEarly(DemoEntryNo: Integer): Integer
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        I: Integer;
        Dummy: Integer;
    begin
        // DEMO: The lock is intentionally taken before unrelated preparation work.
        PerfDemoEntry.LockTable();
        for I := 1 to 200000 do
            Dummy += I mod 17;
        if PerfDemoEntry.Get(DemoEntryNo) then begin
            PerfDemoEntry.Amount += 0.01;
            PerfDemoEntry.Modify();
        end;
        exit(Dummy);
    end;

    procedure Good_LockLate(DemoEntryNo: Integer): Integer
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        I: Integer;
        Dummy: Integer;
    begin
        for I := 1 to 200000 do
            Dummy += I mod 17;
        PerfDemoEntry.LockTable();
        if PerfDemoEntry.Get(DemoEntryNo) then begin
            PerfDemoEntry.Amount += 0.01;
            PerfDemoEntry.Modify();
        end;
        exit(Dummy);
    end;
}
