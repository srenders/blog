codeunit 60201 "TAI Add Serv. Decl. Lines"
{
    procedure AddCorrectionLines(ServiceDeclarationHeader: Record "Service Declaration Header")
    var
        TAICorrection: Record "TAI Serv. Decl. Correction";
        ValueEntry: Record "Value Entry";
        ServiceDeclLine: Record "Service Declaration Line";
        LineNo: Integer;
    begin
        // Get last line number
        ServiceDeclLine.SetRange("Service Declaration No.", ServiceDeclarationHeader."No.");
        if ServiceDeclLine.FindLast() then
            LineNo := ServiceDeclLine."Line No."
        else
            LineNo := 0;

        // Process all active corrections
        TAICorrection.SetRange("Applicable For Serv. Decl.", true);
        if TAICorrection.FindSet() then
            repeat
                if ValueEntry.Get(TAICorrection."Value Entry No.") then
                    // Check if Value Entry is in the date range
                    if (ValueEntry."Posting Date" >= ServiceDeclarationHeader."Starting Date") and
                       (ValueEntry."Posting Date" <= ServiceDeclarationHeader."Ending Date")
                    then
                        // Check if line already exists for this Value Entry
                        if not LineExistsForValueEntry(ServiceDeclarationHeader."No.", TAICorrection."Value Entry No.") then begin
                            LineNo += 10000;
                            CreateServiceDeclLine(ServiceDeclarationHeader."No.", LineNo, ValueEntry, TAICorrection);
                        end;
            until TAICorrection.Next() = 0;
    end;

    local procedure LineExistsForValueEntry(ServiceDeclNo: Code[20]; ValueEntryNo: Integer): Boolean
    var
        ServiceDeclLine: Record "Service Declaration Line";
        ValueEntry: Record "Value Entry";
    begin
        if not ValueEntry.Get(ValueEntryNo) then
            exit(false);

        ServiceDeclLine.SetRange("Service Declaration No.", ServiceDeclNo);
        ServiceDeclLine.SetRange("Document Type", ValueEntry."Document Type");
        ServiceDeclLine.SetRange("Document No.", ValueEntry."Document No.");
        ServiceDeclLine.SetRange("Posting Date", ValueEntry."Posting Date");
        exit(not ServiceDeclLine.IsEmpty());
    end;

    local procedure CreateServiceDeclLine(ServiceDeclNo: Code[20]; LineNo: Integer; ValueEntry: Record "Value Entry"; Correction: Record "TAI Serv. Decl. Correction")
    var
        ServiceDeclLine: Record "Service Declaration Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if not ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
            exit;

        ServiceDeclLine.Init();
        ServiceDeclLine."Service Declaration No." := ServiceDeclNo;
        ServiceDeclLine."Line No." := LineNo;
        ServiceDeclLine."Service Transaction Code" := Correction."Service Transaction Type Code";

        // Use Country/Region Code from correction if specified, otherwise from Item Ledger Entry
        if Correction."Country/Region Code" <> '' then
            ServiceDeclLine."Country/Region Code" := Correction."Country/Region Code"
        else
            ServiceDeclLine."Country/Region Code" := ItemLedgerEntry."Country/Region Code";

        // Set Currency Code from correction if specified
        if Correction."Currency Code" <> '' then
            ServiceDeclLine."Currency Code" := Correction."Currency Code";

        // Set VAT Reg. No. from correction if specified
        if Correction."VAT Reg. No." <> '' then
            ServiceDeclLine."VAT Reg. No." := Correction."VAT Reg. No.";

        // Set Item Charge No. from correction if specified
        if Correction."Item Charge No." <> '' then
            ServiceDeclLine."Item Charge No." := Correction."Item Charge No.";

        // Set Description from correction if specified, otherwise from Item Ledger Entry
        if Correction.Description <> '' then
            ServiceDeclLine.Description := Correction.Description
        else
            ServiceDeclLine.Description := ItemLedgerEntry.Description;

        ServiceDeclLine."Document Type" := ValueEntry."Document Type";
        ServiceDeclLine."Document No." := ValueEntry."Document No.";
        ServiceDeclLine."Posting Date" := ValueEntry."Posting Date";

        // Set amounts - use correction values if specified, otherwise from Value Entry
        case ValueEntry."Document Type" of
            ValueEntry."Document Type"::"Sales Invoice":
                begin
                    if Correction."Sales Amount (LCY)" <> 0 then
                        ServiceDeclLine."Sales Amount (LCY)" := Correction."Sales Amount (LCY)"
                    else
                        ServiceDeclLine."Sales Amount (LCY)" := ValueEntry."Sales Amount (Actual)";

                    if Correction."Sales Amount" <> 0 then
                        ServiceDeclLine."Sales Amount" := Correction."Sales Amount";
                end;
            ValueEntry."Document Type"::"Purchase Invoice":
                begin
                    if Correction."Purchase Amount (LCY)" <> 0 then
                        ServiceDeclLine."Purchase Amount (LCY)" := Correction."Purchase Amount (LCY)"
                    else
                        ServiceDeclLine."Purchase Amount (LCY)" := ValueEntry."Purchase Amount (Actual)";

                    if Correction."Purchase Amount" <> 0 then
                        ServiceDeclLine."Purchase Amount" := Correction."Purchase Amount";
                end;
        end;

        ServiceDeclLine.Insert(true);
    end;
}
