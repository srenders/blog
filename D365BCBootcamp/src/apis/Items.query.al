query 80200 Items
{
    QueryType = API;
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'item';
    EntitySetName = 'items';
    DataAccessIntent = ReadOnly;
 
    
    elements
    {
        dataitem(Item;Item)
        {
            column(itemCategoryCode; "Item Category Code") { }
            column(itemNo; "No.") { }
            column(itemDescription; Description) { }
            column(baseUnitOfMeasure; "Base Unit of Measure") { }
            column("type"; "Type") { }
            column(unitPrice; "Unit Price") { }
            column(unitCost; "Unit Cost") { }
            column(reorderPoint; "Reorder Point") { }
        }
    }
}