query 70102 ItemLedgers
{
    QueryType = API;
    DataAccessIntent = ReadOnly;
    Caption = 'DEMO - ItemLedgers Query';
    QueryCategory = 'Items';
    UsageCategory = ReportsAndAnalysis;

    EntityName = 'itemLedgers';
    EntitySetName = 'itemLedgers';
    EntityCaption = 'itemLedgers';
    APIGroup = 'powerBI';
    APIVersion = 'v1.0';
    APIPublisher = 'powerBI';

    elements
    {
        dataitem(ItemLedgers; "Item Ledger Entry")
        {
            column(itemNo; "Item No.") { }
            column(postingDate; "Posting Date") { }
            column(locationCode; "Location Code") { }
            column(documentType; "Document Type") { }
            column(quantity; Quantity) { Method = Sum; }
        }
    }
}