page 50121 ItemCuePart
{
    PageType = CardPart;
    SourceTable = "Activities Cue";
    Editable = false;
    Caption = 'Item Availability Cue';

    layout
    {
        area(content)
        {
            cuegroup(Items)
            {
                field(ItemsWithNegAv; ItemsWithNegAv)
                {
                    ApplicationArea = all;
                    DrillDownPageId = AvailabilityList;
                    Caption = 'Items With Negative Availability';

                }
                field(ItemsWithNegInv; ItemsWithNegInv)
                {
                    ApplicationArea = all;
                    Caption = 'Items With Negative Inventory';
                    DrillDownPageId = AvailabilityList;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        if not get() then insert();
    end;

    trigger OnAfterGetRecord()
    begin
        rec.ItemsWithNegAv := rec.CountItemsWithNegAv();
    end;
}