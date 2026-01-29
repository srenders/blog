codeunit 60202 "TAI Suggest Serv. Decl. Corr."
{
    TableNo = "TAI Service Decl. Fix Setup";

    trigger OnRun()
    begin
        SuggestCorrections(Rec);
    end;

    procedure SuggestCorrections(Setup: Record "TAI Service Decl. Fix Setup")
    var
        ValueEntry: Record "Value Entry";
        TAICorrection: Record "TAI Serv. Decl. Correction";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ExistingCorrection: Record "TAI Serv. Decl. Correction";
        CorrectionsCreated: Integer;
        ConfirmLbl: Label 'Suggest corrections for Value Entries missing Service Declaration fields?\Filter: %1\EU Only: %2\Period: %3..%4\Default Code: %5', Comment = '%1 = Filter Method, %2 = EU Only, %3 = Starting Date, %4 = Ending Date, %5 = Service Transaction Type Code';
    begin
        ValidateSetup(Setup);

        if not Confirm(ConfirmLbl, false,
            Setup."Filter Method",
            Setup."Limit to EU Countries",
            Setup."Starting Date",
            Setup."Ending Date",
            Setup."Default Serv. Trans. Type Code")
        then
            exit;

        CorrectionsCreated := 0;

        ValueEntry.SetFilter("Document Type", '%1|%2|%3|%4',
            ValueEntry."Document Type"::"Sales Invoice",
            ValueEntry."Document Type"::"Purchase Invoice",
            ValueEntry."Document Type"::"Sales Credit Memo",
            ValueEntry."Document Type"::"Purchase Credit Memo");
        ValueEntry.SetRange("Posting Date", Setup."Starting Date", Setup."Ending Date");

        if not ValueEntry.FindSet() then begin
            Message('No Value Entries found in date range %1..%2 with Sales/Purchase Invoices and Credit Memos document type.', Setup."Starting Date", Setup."Ending Date");
            exit;
        end;

        repeat
            if ShouldCreateCorrection(ValueEntry, Setup) then begin
                // Check if correction already exists for this Value Entry
                ExistingCorrection.Reset();
                ExistingCorrection.SetRange("Value Entry No.", ValueEntry."Entry No.");
                if not ExistingCorrection.FindFirst() then begin
                    Clear(TAICorrection);
                    TAICorrection.Init();
                    TAICorrection."Value Entry No." := ValueEntry."Entry No.";
                    TAICorrection.Validate("Value Entry No.");
                    TAICorrection."Service Transaction Type Code" := Setup."Default Serv. Trans. Type Code";
                    TAICorrection."Applicable For Serv. Decl." := true;

                    // Set Description from Item Ledger Entry
                    if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                        TAICorrection.Description := ItemLedgerEntry.Description;

                    // Get Country/Region Code from Bill-to Customer/Pay-to Vendor
                    TAICorrection."Country/Region Code" := GetCountryRegionCode(ValueEntry);

                    // Get VAT Reg. No. from Bill-to Customer/Pay-to Vendor
                    TAICorrection."VAT Reg. No." := GetVATRegNo(ValueEntry);

                    // Set amounts from Value Entry
                    case ValueEntry."Document Type" of
                        ValueEntry."Document Type"::"Sales Invoice",
                        ValueEntry."Document Type"::"Sales Credit Memo":
                            TAICorrection."Sales Amount (LCY)" := ValueEntry."Sales Amount (Actual)";
                        ValueEntry."Document Type"::"Purchase Invoice",
                        ValueEntry."Document Type"::"Purchase Credit Memo":
                            TAICorrection."Purchase Amount (LCY)" := ValueEntry."Purchase Amount (Actual)";
                    end;

                    TAICorrection.Insert(true);
                    CorrectionsCreated += 1;
                end;
            end;
        until ValueEntry.Next() = 0;

        UpdateSetupStats(Setup, CorrectionsCreated);
        Message('Created %1 correction entries.', CorrectionsCreated);
    end;

    local procedure ValidateSetup(Setup: Record "TAI Service Decl. Fix Setup")
    var
        ErrorMsg: Label 'Please specify %1.', Comment = '%1 = Field Caption';
    begin
        if Setup."Starting Date" = 0D then
            Error(ErrorMsg, Setup.FieldCaption("Starting Date"));
        if Setup."Ending Date" = 0D then
            Error(ErrorMsg, Setup.FieldCaption("Ending Date"));
        if Setup."Default Serv. Trans. Type Code" = '' then
            Error(ErrorMsg, Setup.FieldCaption("Default Serv. Trans. Type Code"));
    end;

    local procedure ShouldCreateCorrection(ValueEntry: Record "Value Entry"; Setup: Record "TAI Service Decl. Fix Setup"): Boolean
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        CountryRegion: Record "Country/Region";
    begin
        case Setup."Filter Method" of
            Setup."Filter Method"::"All Entries":
                begin
                    if Setup."Limit to EU Countries" then begin
                        if not ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                            exit(false);
                        if ItemLedgerEntry."Country/Region Code" = '' then
                            exit(false);
                        if not CountryRegion.Get(ItemLedgerEntry."Country/Region Code") then
                            exit(false);
                        if CountryRegion."EU Country/Region Code" = '' then
                            exit(false);
                    end;
                    exit(true);
                end;

            Setup."Filter Method"::"Item Type Service":
                begin
                    if not Item.Get(ValueEntry."Item No.") then
                        exit(false);
                    if Item.Type <> Item.Type::Service then
                        exit(false);
                    if Setup."Limit to EU Countries" then begin
                        if not ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                            exit(false);
                        if ItemLedgerEntry."Country/Region Code" = '' then
                            exit(false);
                        if not CountryRegion.Get(ItemLedgerEntry."Country/Region Code") then
                            exit(false);
                        if CountryRegion."EU Country/Region Code" = '' then
                            exit(false);
                    end;
                    exit(true);
                end;

            Setup."Filter Method"::"VAT EU Service":
                exit(false); // Not supported
        end;
        exit(false);
    end;

    local procedure UpdateSetupStats(var Setup: Record "TAI Service Decl. Fix Setup"; CorrectionsCreated: Integer)
    begin
        Setup."Last Run Date" := CreateDateTime(Today, Time);
        Setup."Lines Created" := CorrectionsCreated;
        Setup.Modify();
    end;

    local procedure GetVATRegNo(ValueEntry: Record "Value Entry"): Text[50]
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        case ValueEntry."Document Type" of
            ValueEntry."Document Type"::"Sales Invoice":
                if SalesInvoiceHeader.Get(ValueEntry."Document No.") then
                    if Customer.Get(SalesInvoiceHeader."Bill-to Customer No.") then
                        exit(Customer."VAT Registration No.");
            ValueEntry."Document Type"::"Sales Credit Memo":
                if SalesCrMemoHeader.Get(ValueEntry."Document No.") then
                    if Customer.Get(SalesCrMemoHeader."Bill-to Customer No.") then
                        exit(Customer."VAT Registration No.");
            ValueEntry."Document Type"::"Purchase Invoice":
                if PurchInvHeader.Get(ValueEntry."Document No.") then
                    if Vendor.Get(PurchInvHeader."Pay-to Vendor No.") then
                        exit(Vendor."VAT Registration No.");
            ValueEntry."Document Type"::"Purchase Credit Memo":
                if PurchCrMemoHeader.Get(ValueEntry."Document No.") then
                    if Vendor.Get(PurchCrMemoHeader."Pay-to Vendor No.") then
                        exit(Vendor."VAT Registration No.");
        end;
        exit('');
    end;

    local procedure GetCountryRegionCode(ValueEntry: Record "Value Entry"): Code[10]
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        case ValueEntry."Document Type" of
            ValueEntry."Document Type"::"Sales Invoice":
                if SalesInvoiceHeader.Get(ValueEntry."Document No.") then
                    if Customer.Get(SalesInvoiceHeader."Bill-to Customer No.") then
                        exit(Customer."Country/Region Code");
            ValueEntry."Document Type"::"Sales Credit Memo":
                if SalesCrMemoHeader.Get(ValueEntry."Document No.") then
                    if Customer.Get(SalesCrMemoHeader."Bill-to Customer No.") then
                        exit(Customer."Country/Region Code");
            ValueEntry."Document Type"::"Purchase Invoice":
                if PurchInvHeader.Get(ValueEntry."Document No.") then
                    if Vendor.Get(PurchInvHeader."Pay-to Vendor No.") then
                        exit(Vendor."Country/Region Code");
            ValueEntry."Document Type"::"Purchase Credit Memo":
                if PurchCrMemoHeader.Get(ValueEntry."Document No.") then
                    if Vendor.Get(PurchCrMemoHeader."Pay-to Vendor No.") then
                        exit(Vendor."Country/Region Code");
        end;
        exit('');
    end;
}
