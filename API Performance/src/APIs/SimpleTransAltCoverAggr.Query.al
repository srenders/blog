query 91114 "Simple Trans Alt Cover Aggr"
{
    Caption = 'Simple Transaction Aggregate Query - Alternative Covering';
    QueryType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionAltCoverAggr';
    EntitySetName = 'simpleTransactionAltCoverAggr';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(SimpleTransAltCovering; "Simple Trans Alt Covering")
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
