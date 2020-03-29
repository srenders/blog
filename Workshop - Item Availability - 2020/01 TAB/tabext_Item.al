tableextension 50125 PagExtItem extends Item
{
    fields
    {
        // Add changes to table fields here
        field(50100; ItemAvailability; Decimal)
        {
            Editable = false;
            Caption = 'Item Availability';
            DataClassification = CustomerContent;
        }
    }
    procedure GetCalcItemsAv(): Decimal
    var
        QtyAvailable: Decimal;
    begin
        clear(QtyAvailable);
        CALCFIELDS(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");
        QtyAvailable := Inventory + "Qty. on Purch. Order" - "Qty. on Sales Order";
        exit(QtyAvailable);
    end;
}