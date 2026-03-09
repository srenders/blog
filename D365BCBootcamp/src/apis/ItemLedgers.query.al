query 80201 ItemLedgers
{
    QueryType = API;
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'itemledger';
    EntitySetName = 'itemledgers';
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(ItemLedgers; "Item Ledger Entry")
        {
            column(documentType; "Document Type") { }
            column(itemNo; "Item No.") { }
            column(postingDate; "Posting Date") { }
            column(locationCode; "Location Code") { }
            column(quantity; Quantity) { Method = Sum; }
        }
    }
}