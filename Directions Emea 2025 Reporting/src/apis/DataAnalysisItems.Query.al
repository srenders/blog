query 70106 DataAnalysisItems
{
    QueryType = API;
    DataAccessIntent = ReadOnly;
    Caption = 'DEMO - DataAnalysisItems';
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
            dataitem(ItemLedgers; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = Item."No.";
                SqlJoinType = LeftOuterJoin;

                column(postingDate; "Posting Date") { }
                column(locationCode; "Location Code") { }
                column(documentType; "Document Type") { Caption = 'Item Ledger Document Type'; }
                column(quantity; Quantity) { Method = Sum; }
                dataitem(ValueEntries; "Value Entry")
                {
                    DataItemLink = "Item Ledger Entry No." = ItemLedgers."Entry No.";
                    SqlJoinType = LeftOuterJoin;
                    column(valueEntriesDocumentType; "Document Type") { Caption = 'Value Entry Document Type'; }
                    column(valueEntriesEntryType; "Item Ledger Entry Type") { Caption = 'Value Entry Entry Type'; }
                    column(valueEntriesSourceType; "Source Type") { Caption = 'Value Entry Source Type'; }
                    column(valueEntriesEntryQuantity; "Item Ledger Entry Quantity") { Method = Sum; }
                }
            }
        }
    }
}