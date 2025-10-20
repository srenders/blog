codeunit 91104 "Minimal Keys Table Generator" implements "ITest Data Generator"
{
    var
        BaseGenerator: Codeunit "Base Test Data Generator";

    procedure InsertTestRecords(NumberOfRecords: Integer)
    var
        SimpleTransMinimalKeys: Record "Simple Trans Minimal Keys";
        i: Integer;
        EntryNo: Integer;
        CustomerList: List of [Code[20]];
        DialogWindow: Dialog;
    begin
        BaseGenerator.LoadCustomerList(CustomerList);
        EntryNo := GetNextEntryNo();

        BaseGenerator.OpenProgressDialog(DialogWindow, GetTableName(), NumberOfRecords);

        for i := 1 to NumberOfRecords do begin
            Clear(SimpleTransMinimalKeys);
            SimpleTransMinimalKeys."Entry No." := EntryNo;
            SimpleTransMinimalKeys."Customer No." := BaseGenerator.GetTestCustomerNoFromList(i, CustomerList);
            SimpleTransMinimalKeys."Posting Date" := BaseGenerator.GetRandomPostingDate(i);
            SimpleTransMinimalKeys."Document Type" := BaseGenerator.GetTestDocumentType(i);
            SimpleTransMinimalKeys."Document No." := 'TEST-' + BaseGenerator.GetFormattedNumber(i);
            SimpleTransMinimalKeys."Description" := 'Test transaction entry ' + Format(i);
            SimpleTransMinimalKeys."Amount (LCY)" := BaseGenerator.GetRandomAmountByDocType(SimpleTransMinimalKeys."Document Type");
            SimpleTransMinimalKeys.Insert(false);

            EntryNo += 10;
            BaseGenerator.UpdateProgressDialog(DialogWindow, i, NumberOfRecords);
        end;

        BaseGenerator.CloseProgressDialog(DialogWindow, NumberOfRecords);
    end;

    procedure TruncateTestRecords()
    var
        SimpleTransMinimalKeys: Record "Simple Trans Minimal Keys";
    begin
        SimpleTransMinimalKeys.SetFilter("Document No.", 'TEST-*');
        if not SimpleTransMinimalKeys.IsEmpty() then
            SimpleTransMinimalKeys.DeleteAll();
    end;

    procedure DeleteAllRecords()
    var
        SimpleTransMinimalKeys: Record "Simple Trans Minimal Keys";
    begin
        SimpleTransMinimalKeys.DeleteAll();
    end;

    procedure GetNextEntryNo(): Integer
    var
        SimpleTransMinimalKeys: Record "Simple Trans Minimal Keys";
    begin
        if SimpleTransMinimalKeys.FindLast() then
            exit(SimpleTransMinimalKeys."Entry No." + 10)
        else
            exit(10);
    end;

    procedure GetTableName(): Text[100]
    begin
        exit('Minimal Keys');
    end;
}
