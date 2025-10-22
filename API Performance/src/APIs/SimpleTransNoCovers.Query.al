query 91109 "Simple Trans No Covers"
{
    Caption = 'Simple Transaction - No Covering';
    QueryType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionNoCoversQuery';
    EntitySetName = 'simpleTransactionNoCoversQuery';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(SimpleTransNoCovering; "Simple Trans No Covers")
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
