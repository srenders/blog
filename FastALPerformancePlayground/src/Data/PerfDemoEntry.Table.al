table 70201 "Perf Demo Entry"
{
    Caption = 'Performance Demo Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(3; Category; Code[20])
        {
            Caption = 'Category';
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; "Is Open"; Boolean)
        {
            Caption = 'Is Open';
        }
        field(7; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(8; "Payload 1"; Text[250]) { }
        field(9; "Payload 2"; Text[250]) { }
        field(10; "Payload 3"; Text[250]) { }
        field(11; "Payload 4"; Text[250]) { }
        field(12; "Payload 5"; Text[250]) { }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(CustomerOpen; "Customer No.", "Is Open")
        {
        }
        key(CategoryPostingDate; Category, "Posting Date")
        {
            SumIndexFields = Amount;
        }
    }
}
