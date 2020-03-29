pageextension 50123 MyItemList extends "Item List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(ItemAvailability; ItemAvailability)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnAfterGetRecord()
    begin
        Rec.ItemAvailability := rec.GetCalcItemsAv();
    end;
}