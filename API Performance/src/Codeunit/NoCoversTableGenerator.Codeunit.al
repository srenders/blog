codeunit 91103 "No Covers Table Generator" implements "ITest Data Generator"
{
    var
        BaseGenerator: Codeunit "Base Test Data Generator";

    procedure InsertTestRecords(NumberOfRecords: Integer)
    var
        SimpleTransNoCovering: Record "Simple Trans No Covers";
        i: Integer;
        EntryNo: Integer;
        CustomerList: List of [Code[20]];
        DialogWindow: Dialog;
    begin
        BaseGenerator.LoadCustomerList(CustomerList);
        EntryNo := GetNextEntryNo();

        BaseGenerator.OpenProgressDialog(DialogWindow, GetTableName(), NumberOfRecords);

        for i := 1 to NumberOfRecords do begin
            Clear(SimpleTransNoCovering);
            SimpleTransNoCovering."Entry No." := EntryNo;
            SimpleTransNoCovering."Customer No." := BaseGenerator.GetTestCustomerNoFromList(i, CustomerList);
            SimpleTransNoCovering."Posting Date" := BaseGenerator.GetRandomPostingDate(i);
            SimpleTransNoCovering."Document Type" := BaseGenerator.GetTestDocumentType(i);
            SimpleTransNoCovering."Document No." := 'TEST-' + BaseGenerator.GetFormattedNumber(i);
            SimpleTransNoCovering."Description" := 'Test transaction entry ' + Format(i);
            SimpleTransNoCovering."Amount (LCY)" := BaseGenerator.GetRandomAmountByDocType(SimpleTransNoCovering."Document Type");
            SimpleTransNoCovering.Insert(false);

            EntryNo += 10;
            BaseGenerator.UpdateProgressDialog(DialogWindow, i, NumberOfRecords);
        end;

        BaseGenerator.CloseProgressDialog(DialogWindow, NumberOfRecords);
    end;

    procedure TruncateTestRecords()
    var
        SimpleTransNoCovering: Record "Simple Trans No Covers";
    begin
        SimpleTransNoCovering.SetFilter("Document No.", 'TEST-*');
        if not SimpleTransNoCovering.IsEmpty() then
            SimpleTransNoCovering.DeleteAll();
    end;

    procedure DeleteAllRecords()
    var
        SimpleTransNoCovering: Record "Simple Trans No Covers";
    begin
        SimpleTransNoCovering.DeleteAll();
    end;

    procedure GetNextEntryNo(): Integer
    var
        SimpleTransNoCovering: Record "Simple Trans No Covers";
    begin
        if SimpleTransNoCovering.FindLast() then
            exit(SimpleTransNoCovering."Entry No." + 10)
        else
            exit(10);
    end;

    procedure GetTableName(): Text[100]
    begin
        exit('No Covering Indexes');
    end;
}
