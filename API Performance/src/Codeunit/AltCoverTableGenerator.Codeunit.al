codeunit 91105 "Alt Cover Table Generator" implements "ITest Data Generator"
{
    var
        BaseGenerator: Codeunit "Base Test Data Generator";

    procedure InsertTestRecords(NumberOfRecords: Integer)
    var
        SimpleTransAltCovering: Record "Simple Trans Alt Covering";
        i: Integer;
        EntryNo: Integer;
        CustomerList: List of [Code[20]];
        DialogWindow: Dialog;
    begin
        BaseGenerator.LoadCustomerList(CustomerList);
        EntryNo := GetNextEntryNo();

        BaseGenerator.OpenProgressDialog(DialogWindow, GetTableName(), NumberOfRecords);

        for i := 1 to NumberOfRecords do begin
            Clear(SimpleTransAltCovering);
            SimpleTransAltCovering."Entry No." := EntryNo;
            SimpleTransAltCovering."Customer No." := BaseGenerator.GetTestCustomerNoFromList(i, CustomerList);
            SimpleTransAltCovering."Posting Date" := BaseGenerator.GetRandomPostingDate(i);
            SimpleTransAltCovering."Document Type" := BaseGenerator.GetTestDocumentType(i);
            SimpleTransAltCovering."Document No." := 'TEST-' + BaseGenerator.GetFormattedNumber(i);
            SimpleTransAltCovering."Description" := 'Test transaction entry ' + Format(i);
            SimpleTransAltCovering."Amount (LCY)" := BaseGenerator.GetRandomAmountByDocType(SimpleTransAltCovering."Document Type");
            SimpleTransAltCovering.Insert(false);

            EntryNo += 10;
            BaseGenerator.UpdateProgressDialog(DialogWindow, i, NumberOfRecords);
        end;

        BaseGenerator.CloseProgressDialog(DialogWindow, NumberOfRecords);
    end;

    procedure TruncateTestRecords()
    var
        SimpleTransAltCovering: Record "Simple Trans Alt Covering";
    begin
        SimpleTransAltCovering.SetFilter("Document No.", 'TEST-*');
        if not SimpleTransAltCovering.IsEmpty() then
            SimpleTransAltCovering.DeleteAll();
    end;

    procedure DeleteAllRecords()
    var
        SimpleTransAltCovering: Record "Simple Trans Alt Covering";
    begin
        SimpleTransAltCovering.DeleteAll();
    end;

    procedure GetNextEntryNo(): Integer
    var
        SimpleTransAltCovering: Record "Simple Trans Alt Covering";
    begin
        if SimpleTransAltCovering.FindLast() then
            exit(SimpleTransAltCovering."Entry No." + 10)
        else
            exit(10);
    end;

    procedure GetTableName(): Text[100]
    begin
        exit('Alternative Covering');
    end;
}
