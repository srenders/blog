table 60201 "TAI Serv. Decl. Correction"
{
    Caption = 'TAI Service Declaration Correction';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Value Entry No."; Integer)
        {
            Caption = 'Value Entry No.';
            TableRelation = "Value Entry";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ValueEntry: Record "Value Entry";
            begin
                if "Value Entry No." = 0 then
                    exit;

                if ValueEntry.Get("Value Entry No.") then begin
                    "Document Type" := ValueEntry."Document Type";
                    "Document No." := ValueEntry."Document No.";
                    "Posting Date" := ValueEntry."Posting Date";
                    "Item No." := ValueEntry."Item No.";
                end;
            end;
        }
        field(20; "Service Transaction Type Code"; Code[20])
        {
            Caption = 'Service Transaction Type Code';
            TableRelation = "Service Transaction Type";
            DataClassification = CustomerContent;
        }
        field(30; "Applicable For Serv. Decl."; Boolean)
        {
            Caption = 'Applicable For Service Declaration';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(40; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(41; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(42; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
            DataClassification = CustomerContent;
        }
        field(43; "Purchase Amount"; Decimal)
        {
            Caption = 'Purchase Amount';
            DataClassification = CustomerContent;
        }
        field(44; "Sales Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(45; "Purchase Amount (LCY)"; Decimal)
        {
            Caption = 'Purchase Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(46; "Item Charge No."; Code[20])
        {
            Caption = 'Item Charge No.';
            TableRelation = "Item Charge";
            DataClassification = CustomerContent;
        }
        field(47; "VAT Reg. No."; Text[50])
        {
            Caption = 'Partner VAT ID';
            DataClassification = CustomerContent;
        }
        field(48; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50; "Document Type"; Enum "Item Ledger Document Type")
        {
            Caption = 'Document Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(51; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(52; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(53; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(100; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(101; "Created By User"; Code[50])
        {
            Caption = 'Created By User';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ValueEntry; "Value Entry No.")
        {
        }
        key(Document; "Document Type", "Document No.", "Posting Date")
        {
        }
    }

    trigger OnInsert()
    begin
        "Created Date Time" := CurrentDateTime;
        "Created By User" := CopyStr(UserId, 1, MaxStrLen("Created By User"));
    end;

    procedure GetCorrection(ValueEntryNo: Integer; var ServTransTypeCode: Code[20]; var CountryRegionCode: Code[10]): Boolean
    begin
        SetRange("Value Entry No.", ValueEntryNo);
        SetRange("Applicable For Serv. Decl.", true);
        if FindFirst() then begin
            ServTransTypeCode := "Service Transaction Type Code";
            CountryRegionCode := "Country/Region Code";
            exit(true);
        end;
        exit(false);
    end;
}
