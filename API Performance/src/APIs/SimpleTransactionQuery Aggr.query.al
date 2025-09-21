query 91100 "Simple Transaction Query Aggr"
{
    Caption = 'Simple Transaction Query Aggr';
    QueryType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionEntryQueryAggr';
    EntitySetName = 'simpleTransactionEntryQueryAggrs';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(SimpleTransactionEntry; "Simple Transaction Entry")
        {

            column(customerNo; "Customer No.")
            {
                Caption = 'Customer No.';
            }

            column(documentType; "Document Type")
            {
                Caption = 'Document Type';
            }
            column(postingDate; "Posting Date")
            {
                Caption = 'Posting Date';
            }

            column(amountLCY; "Amount (LCY)")
            {
                Caption = 'Amount (LCY)';
                Method = Sum;
            }
        }
    }
}