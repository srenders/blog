query 91110 "Simple Trans Minimal"
{
    Caption = 'Simple Transaction - Minimal Keys';
    QueryType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionMinimalQuery';
    EntitySetName = 'simpleTransactionMinimalQuery';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(SimpleTransMinimalKeys; "Simple Trans Minimal Keys")
        {
            column(entryNo; "Entry No.")
            {
                Caption = 'Entry No.';
            }

            column(customerNo; "Customer No.")
            {
                Caption = 'Customer No.';
            }

            column(postingDate; "Posting Date")
            {
                Caption = 'Posting Date';
            }

            column(documentType; "Document Type")
            {
                Caption = 'Document Type';
            }

            column(documentNo; "Document No.")
            {
                Caption = 'Document No.';
            }

            column(description; Description)
            {
                Caption = 'Description';
            }

            column(amountLCY; "Amount (LCY)")
            {
                Caption = 'Amount (LCY)';
            }
        }
    }
}
