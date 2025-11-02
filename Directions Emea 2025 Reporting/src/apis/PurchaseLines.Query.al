query 70104 PurchaseLines
{
    QueryType = API;
    DataAccessIntent = ReadOnly;
    Caption = 'DEMO - PurchaseLines Query';
    QueryCategory = 'Items';
    UsageCategory = ReportsAndAnalysis;

    EntityName = 'purchaseLines';
    EntitySetName = 'purchaseLines';
    EntityCaption = 'purchaseLines';
    APIGroup = 'powerBI';
    APIVersion = 'v1.0';
    APIPublisher = 'powerBI';


    elements
    {
        dataitem(PurchaseLines; "Purchase Line")
        {
            DataItemTableFilter = Type = const("Item");
            column(itemNo; "No.") { }
            column(expectedReceiptDate; "Expected Receipt Date") { }
            column(locationCode; "Location Code") { }
            column(documentType; "Document Type") { }
            column(quantity; Quantity) { Method = Sum; }
        }
    }
}