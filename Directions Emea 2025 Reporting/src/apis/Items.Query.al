query 70101 Items
{
    QueryType = API;
    DataAccessIntent = ReadOnly;
    Caption = 'DEMO - Items Query';
    QueryCategory = 'Items';
    UsageCategory = ReportsAndAnalysis;

    EntityName = 'items';
    EntitySetName = 'items';
    EntityCaption = 'items';
    APIGroup = 'powerBI';
    APIVersion = 'v1.0';
    APIPublisher = 'powerBI';

    elements
    {
        dataitem(Item; Item)
        {

            column(itemNo; "No.") { }
            column(itemDescription; Description) { }
            column("itemType"; "Type") { }
            column(reorderPoint; "Reorder Point") { }
            column(itemUnitPrice; "Unit Price") { }
            column(itemUnitCost; "Unit Cost") { }
        }
    }
}