pageextension 70100 ItemList extends "Item List"
{
    layout
    {
        // Add changes to page layout here
        addafter(InventoryField)
        {
            field(AvailabilityVar; AvailabilityVar)
            {
                ApplicationArea = All;
                Caption = 'Availability';
                ToolTip = 'Availability';
                Editable = false;
                StyleExpr = "FieldStyle";
            }
        }
    }
    actions
    {
        addlast(Functions)
        {
            action(GetAvailabilitySelected)
            {
                ApplicationArea = All;
                Caption = 'Calculate Availability Selected';
                ToolTip = 'Calculate Availability Selected';
                Image = Inventory;
                ShortcutKey = 'Shift+Ctrl+A';
                

                trigger OnAction()
                begin
                    CalculateAvailabilitySelected()
                end;
            }
        }
    }

    var
        AvailabilityVar: Integer;
        FieldStyle: Text;

    trigger OnAfterGetRecord()
    begin
        //
        rec.CalcFields(rec."Qty. on Purch. Order", rec."Qty. on Sales Order", rec.Inventory);
        AvailabilityVar := rec.Inventory + rec."Qty. on Purch. Order" - rec."Qty. on Sales Order";

        if AvailabilityVar = rec.Inventory then FieldStyle := 'Standard';
        if AvailabilityVar < rec.Inventory then FieldStyle := 'Attention';
        if AvailabilityVar > rec.Inventory then FieldStyle := 'Favorable';
    end;

    local procedure CalculateAvailabilitySelected()
    var
        Item: Record Item;
        AvailabilityTotal: Decimal;
    begin
        Clear(Item);
        clear(AvailabilityTotal);

        CurrPage.SetSelectionFilter(Item);
        if Item.Count = 0 then
            Error('No items selected!')
        else
            repeat
                Item.CalcFields(Item."Qty. on Purch. Order", Item."Qty. on Sales Order", Item.Inventory);
                AvailabilityTotal += Item.Inventory + Item."Qty. on Purch. Order" - Item."Qty. on Sales Order";
            until item.Next() = 0;
        Message('The total availability of the selected items is %1', AvailabilityTotal);
    end;
}