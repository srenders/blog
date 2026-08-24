codeunit 70201 "Perf Data Generator"
{
    procedure GenerateEntries(NumberOfEntries: Integer)
    var
        PerfDemoEntry: Record "Perf Demo Entry";
        Customer: Record Customer;
        EntryNo: Integer;
        CustomerNos: List of [Code[20]];
        CustomerNo: Code[20];
    begin
        if NumberOfEntries <= 0 then
            Error('Number of entries must be greater than zero.');

        Customer.SetLoadFields("No.");
        if Customer.FindSet() then
            repeat
                CustomerNos.Add(Customer."No.");
            until Customer.Next() = 0;

        if CustomerNos.Count() = 0 then
            Error('Create at least one customer before generating demo data.');

        PerfDemoEntry.DeleteAll();

        for EntryNo := 1 to NumberOfEntries do begin
            CustomerNo := CustomerNos.Get(((EntryNo - 1) mod CustomerNos.Count()) + 1);
            PerfDemoEntry.Init();
            PerfDemoEntry."Entry No." := EntryNo;
            PerfDemoEntry."Customer No." := CustomerNo;
            PerfDemoEntry.Category := StrSubstNo(CategoryLbl, ((EntryNo - 1) mod 10) + 1);
            PerfDemoEntry.Amount := (EntryNo mod 1000) / 10;
            PerfDemoEntry.Description := StrSubstNo(DescriptionLbl, EntryNo);
            PerfDemoEntry."Is Open" := (EntryNo mod 3) <> 0;
            PerfDemoEntry."Posting Date" := Today() - (EntryNo mod 365);
            PerfDemoEntry."Payload 1" := CopyStr(PadStr('Payload', 200, 'X'), 1, MaxStrLen(PerfDemoEntry."Payload 1"));
            PerfDemoEntry."Payload 2" := PerfDemoEntry."Payload 1";
            PerfDemoEntry."Payload 3" := PerfDemoEntry."Payload 1";
            PerfDemoEntry."Payload 4" := PerfDemoEntry."Payload 1";
            PerfDemoEntry."Payload 5" := PerfDemoEntry."Payload 1";
            PerfDemoEntry.Insert();
        end;
    end;

    procedure ClearEntries()
    var
        PerfDemoEntry: Record "Perf Demo Entry";
    begin
        PerfDemoEntry.DeleteAll();
    end;

    var
        CategoryLbl: Label 'CAT%1', Comment = '%1 is the deterministic category number.';
        DescriptionLbl: Label 'Performance demo entry %1', Comment = '%1 is the deterministic entry number.';
}
