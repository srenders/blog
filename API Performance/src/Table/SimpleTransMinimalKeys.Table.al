table 91104 "Simple Trans Minimal Keys"
{
    Caption = 'Simple Transaction Entry - Minimal Keys';
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
            TableRelation = Customer;
        }

        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        field(4; "Document Type"; Enum "Simple Document Type")
        {
            Caption = 'Document Type';
        }

        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(6; "Description"; Text[100])
        {
            Caption = 'Description';
        }

        field(7; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            AutoFormatType = 1;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        // Only primary key - test performance with minimal indexing
        // This will force table scans for most queries
    }

    procedure GetNextEntryNo(): Integer
    var
        SimpleTransMinimalKeys: Record "Simple Trans Minimal Keys";
    begin
        if SimpleTransMinimalKeys.FindLast() then
            exit(SimpleTransMinimalKeys."Entry No." + 10)
        else
            exit(10);
    end;
}
