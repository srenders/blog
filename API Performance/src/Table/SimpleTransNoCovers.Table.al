table 91103 "Simple Trans No Covers"
{
    Caption = 'Simple Transaction Entry - No Covering Indexes';
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

        // Regular key without covering - for comparison
        key(QueryNoCovering; "Posting Date", "Customer No.") { }

        // Regular key without SumIndexFields - for comparison
        key(DateAnalytics; "Customer No.", "Document Type", "Posting Date") { }
    }

    procedure GetNextEntryNo(): Integer
    var
        SimpleTransNoCovering: Record "Simple Trans No Covers";
    begin
        if SimpleTransNoCovering.FindLast() then
            exit(SimpleTransNoCovering."Entry No." + 10)
        else
            exit(10);
    end;
}
