query 91111 "Simple Trans Alt Cover Query"
{
    Caption = 'Simple Transaction Query - Alternative Covering';
    QueryType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionAltCoverQuery';
    EntitySetName = 'simpleTransactionAltCoverQuery';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(SimpleTransAltCovering; "Simple Trans Alt Covering")
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
