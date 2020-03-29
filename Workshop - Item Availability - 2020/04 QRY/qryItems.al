query 50112 _qryItems
{
    Caption = '_qryItems';

    elements
    {
        dataitem(Item; Item)
        {
            column(ItemNo; "No.")
            {
            }
            column(ItemDescription; Description)
            {
            }
            column(Category; "Item Category Code")
            {

            }
            column(UnitCost; "Unit Cost")
            {

            }
            column(UnitPrice; "Unit Price")
            {

            }
            column(Inventory; Inventory)
            {

            }
            column(QtyOnSalesOrder; "Qty. on Sales Order")
            {

            }
            column(QtyOnPurchOrder; "Qty. on Purch. Order")
            {

            }


        }
    }

    trigger OnBeforeOpen();
    begin
    end;
}