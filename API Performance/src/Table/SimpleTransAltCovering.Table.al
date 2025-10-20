table 91105 "Simple Trans Alt Covering"
{
    Caption = 'Simple Transaction Entry - Alternative Covering Strategy';
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

        // Alternative covering strategy - all fields included (except primary key)
        key(QueryCoveringAll; "Posting Date", "Customer No.")
        {
            IncludedFields = "Document Type", "Document No.", Description, "Amount (LCY)";
        }

        // Alternative covering for customer-based queries
        key(CustomerCovering; "Customer No.", "Posting Date")
        {
            IncludedFields = "Document Type", "Document No.", Description, "Amount (LCY)";
        }

        // Date analytics with covering instead of SumIndexFields
        key(DateAnalyticsCovering; "Customer No.", "Document Type", "Posting Date")
        {
            IncludedFields = "Amount (LCY)", Description;
        }
    }

    procedure GetNextEntryNo(): Integer
    var
        SimpleTransAltCovering: Record "Simple Trans Alt Covering";
    begin
        if SimpleTransAltCovering.FindLast() then
            exit(SimpleTransAltCovering."Entry No." + 10)
        else
            exit(10);
    end;
}
