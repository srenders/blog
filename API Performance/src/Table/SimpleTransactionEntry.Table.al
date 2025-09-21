table 91100 "Simple Transaction Entry"
{
    Caption = 'Simple Transaction Entry';
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

        key(CustomerPostingDate; "Customer No.") { }

        key(DocumentType; "Document Type") { }

        key(PostingDate; "Posting Date") { }

        key(QueryCovering; "Posting Date", "Customer No.")
        {
            IncludedFields = "Document Type", Description, "Amount (LCY)";
        }

        key(DateAnalytics; "Customer No.", "Document Type","Posting Date")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    procedure GetNextEntryNo(): Integer
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
    begin
        if SimpleTransactionEntry.FindLast() then
            exit(SimpleTransactionEntry."Entry No." + 10)
        else
            exit(10); // Start with 10 if no records exist
    end;
}