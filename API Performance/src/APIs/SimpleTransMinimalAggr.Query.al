query 91113 "Simple Trans Minimal Aggr"
{
    Caption = 'Simple Transaction Aggregate Query - Minimal Keys';
    QueryType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionMinimalAggr';
    EntitySetName = 'simpleTransactionMinimalAggr';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(SimpleTransMinimalKeys; "Simple Trans Minimal Keys")
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
