tableextension 50126 MyActivitiesCue extends "Activities Cue"
{
    fields
    {
        // Add changes to table fields here
        field(50002; ItemsWithNegInv; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Item WHERE (Inventory = FILTER (< 0)));
            Editable = false;
            Caption = 'Items With Neg Inv';
        }
        field(50003; ItemsWithNegAv; integer)
        {
            Editable = false;
            Caption = 'Items With Neg Av';
            DataClassification = CustomerContent;
        }
    }
    procedure CountItemsWithNegAv(): Integer
    var
        Item: Record Item;
        QtyAvailable: Decimal;
        Counter: Integer;
    begin
        clear(Item);
        if Item.findset() then
            repeat
                clear(QtyAvailable);
                QtyAvailable := Item.GetCalcItemsAv();
                if QtyAvailable < 0 then
                    Counter += 1;
            until Item.Next() = 0;
        exit(Counter);
    end;
}