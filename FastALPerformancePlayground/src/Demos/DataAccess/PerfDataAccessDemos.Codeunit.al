codeunit 70202 "Perf Data Access Demos"
{
    procedure Bad_FullRecordRead(): Decimal
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        Total: Decimal;
    begin
        // DEMO: Intentionally reads the complete record as the baseline.
        if PerfDemoEntry.FindSet() then
            repeat
                Total += PerfDemoEntry.Amount;
            until PerfDemoEntry.Next() = 0;
        exit(Total);
    end;

    procedure Good_PartialRecordRead(): Decimal
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        Total: Decimal;
    begin
        // DEMO: Only load the normal field needed by the loop.
        PerfDemoEntry.SetLoadFields(Amount);
        if PerfDemoEntry.FindSet() then
            repeat
                Total += PerfDemoEntry.Amount;
            until PerfDemoEntry.Next() = 0;
        exit(Total);
    end;

    procedure Bad_JitLoadTrap(): Integer
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        DemoRecordRef: RecordRef;
        DescriptionField: FieldRef;
        Sink: Integer;
    begin
        // DEMO: Description was not loaded. Accessing it can trigger a JIT load.
        PerfDemoEntry.SetLoadFields(Amount);
        if PerfDemoEntry.FindSet() then
            repeat
                DemoRecordRef.GetTable(PerfDemoEntry);
                DescriptionField := DemoRecordRef.Field(PerfDemoEntry.FieldNo(Description));
                Sink += StrLen(Format(DescriptionField.Value()));
            until PerfDemoEntry.Next() = 0;
        exit(Sink);
    end;

    procedure Bad_LoopSum(): Decimal
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        Total: Decimal;
    begin
        PerfDemoEntry.SetRange(Category, 'CAT1');
        PerfDemoEntry.SetLoadFields(Amount);
        if PerfDemoEntry.FindSet() then
            repeat
                Total += PerfDemoEntry.Amount;
            until PerfDemoEntry.Next() = 0;
        exit(Total);
    end;

    procedure Good_CalcSums(): Decimal
    var
        PerfDemoEntry: Record "Perf Demo Entry";
    begin
        PerfDemoEntry.SetRange(Category, 'CAT1');
        PerfDemoEntry.CalcSums(Amount);
        exit(PerfDemoEntry.Amount);
    end;

    procedure Good_FindFirst(): Decimal
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        Value: Decimal;
    begin
        PerfDemoEntry.SetRange(Category, 'CAT1');
        if PerfDemoEntry.FindFirst() then
            Value := PerfDemoEntry.Amount;
        exit(Value);
    end;

    procedure Bad_FindSetForOne(): Decimal
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        Value: Decimal;
    begin
        PerfDemoEntry.SetRange(Category, 'CAT1');
        if PerfDemoEntry.FindSet() then begin
            Value := PerfDemoEntry.Amount;
            PerfDemoEntry.Next();
        end;
        exit(Value);
    end;

    procedure Good_GetByPrimaryKey(): Decimal
    var
        PerfDemoEntry: Record "Perf Demo Entry";
    begin
        // DEMO: Get describes the intent when the primary key is known.
        if PerfDemoEntry.Get(1) then
            exit(PerfDemoEntry.Amount);
        exit(0);
    end;

    procedure Good_IndexedFilter(): Decimal
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        Total: Decimal;
    begin
        // DEMO: These filters align with the CategoryPostingDate key prefix.
        PerfDemoEntry.SetRange(Category, 'CAT1');
        PerfDemoEntry.SetRange("Posting Date", CalcDate('<-30D>', Today()), Today());
        PerfDemoEntry.SetLoadFields(Amount);
        if PerfDemoEntry.FindSet() then
            repeat
                Total += PerfDemoEntry.Amount;
            until PerfDemoEntry.Next() = 0;
        exit(Total);
    end;
}
