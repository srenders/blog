query 80203 Sales
{
    QueryType = API;
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'sale';
    EntitySetName = 'sales';
    DataAccessIntent = ReadOnly;


    elements
    {
        dataitem(SalesLines; "Sales Line")
        {
            column(documentType; "Document Type") { }
            column("type"; "Type") { }
            column(itemNo; "No.") { }
            column(locationCode; "Location Code") { }
            column(shipmentDate; "Shipment Date") { }
            column(quantity; Quantity) { Method = Sum; }
        }
    }
}