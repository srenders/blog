codeunit 91102 "Original Table Generator" implements "ITest Data Generator"
{
    var
        BaseGenerator: Codeunit "Base Test Data Generator";

    procedure InsertTestRecords(NumberOfRecords: Integer)
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
        i: Integer;
        EntryNo: Integer;
        CustomerList: List of [Code[20]];
        DialogWindow: Dialog;
    begin
        BaseGenerator.LoadCustomerList(CustomerList);
        EntryNo := GetNextEntryNo();

        BaseGenerator.OpenProgressDialog(DialogWindow, GetTableName(), NumberOfRecords);

        for i := 1 to NumberOfRecords do begin
            Clear(SimpleTransactionEntry);
            SimpleTransactionEntry."Entry No." := EntryNo;
            SimpleTransactionEntry."Customer No." := BaseGenerator.GetTestCustomerNoFromList(i, CustomerList);
            SimpleTransactionEntry."Posting Date" := BaseGenerator.GetRandomPostingDate(i);
            SimpleTransactionEntry."Document Type" := BaseGenerator.GetTestDocumentType(i);
            SimpleTransactionEntry."Document No." := 'TEST-' + BaseGenerator.GetFormattedNumber(i);
            SimpleTransactionEntry."Description" := 'Test transaction entry ' + Format(i);
            SimpleTransactionEntry."Amount (LCY)" := BaseGenerator.GetRandomAmountByDocType(SimpleTransactionEntry."Document Type");
            SimpleTransactionEntry.Insert(false);

            EntryNo += 10;
            BaseGenerator.UpdateProgressDialog(DialogWindow, i, NumberOfRecords);
        end;

        BaseGenerator.CloseProgressDialog(DialogWindow, NumberOfRecords);
    end;

    procedure TruncateTestRecords()
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
    begin
        SimpleTransactionEntry.SetFilter("Document No.", 'TEST-*');
        if not SimpleTransactionEntry.IsEmpty() then
            SimpleTransactionEntry.DeleteAll();
    end;

    procedure DeleteAllRecords()
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
    begin
        SimpleTransactionEntry.DeleteAll();
    end;

    procedure GetNextEntryNo(): Integer
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
    begin
        if SimpleTransactionEntry.FindLast() then
            exit(SimpleTransactionEntry."Entry No." + 10)
        else
            exit(10);
    end;

    procedure GetTableName(): Text[100]
    begin
        exit('Original (With Covering)');
    end;
}
