query 91112 "Simple Trans No Covers Aggr"
{
    Caption = 'Simple Transaction Aggregate - No Covering';
    QueryType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionNoCoversAggr';
    EntitySetName = 'simpleTransactionNoCoversAggr';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(SimpleTransNoCovering; "Simple Trans No Covers")
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
