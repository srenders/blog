query 70103 SalesLines
{
    QueryType = API;
    DataAccessIntent = ReadOnly;
    Caption = 'DEMO - SalesLines Query';
    QueryCategory = 'Items';
    UsageCategory = ReportsAndAnalysis;

    EntityName = 'salesLines';
    EntitySetName = 'salesLines';
    EntityCaption = 'salesLines';
    APIGroup = 'powerBI';
    APIVersion = 'v1.0';
    APIPublisher = 'powerBI';

    elements
    {
        dataitem(SalesLines; "Sales Line")
        {
            DataItemTableFilter = Type = const("Item");
            column(itemNo; "No.") { }
            column(shipmentDate; "Shipment Date") { }
            column(locationCode; "Location Code") { }
            column(documentType; "Document Type") { }
            column(quantity; Quantity) { Method = Sum; }
        }
    }
}