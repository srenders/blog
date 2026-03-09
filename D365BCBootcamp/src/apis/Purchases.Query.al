query 80202 Purchases
{
    QueryType = API;
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'purchase';
    EntitySetName = 'purchases';
    DataAccessIntent = ReadOnly;


    elements
    {
        dataitem(PurchaseLines; "Purchase Line")
        {
            column(documentType; "Document Type") { }
            column("type"; "Type") { }
            column(itemNo; "No.") { }
            column(locationCode; "Location Code") { }
            column(expectedReceiptDate; "Expected Receipt Date") { }
            column(quantity; Quantity) { Method = Sum; }
        }
    }
}