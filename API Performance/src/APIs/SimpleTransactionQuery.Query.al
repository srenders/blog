query 91101 "Simple Transaction Query"
{
    Caption = 'Simple Transaction Query';
    QueryType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionEntryQuery';
    EntitySetName = 'simpleTransactionEntryQuerys';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(SimpleTransactionEntry; "Simple Transaction Entry")
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