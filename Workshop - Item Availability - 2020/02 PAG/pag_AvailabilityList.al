page 50120 AvailabilityList
{
    PageType = List;
    Editable = false;
    SourceTable = Item;
    SourceTableTemporary = true;
    UsageCategory = Lists;
    Caption = 'Availability List';
    ApplicationArea = all;
    CardPageId = 31;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Inventory; Inventory)
                {
                    ApplicationArea = All;
                }
                field(ItemAvailability; ItemAvailability)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("PowerBIReportFactbox"; "Power BI Report FactBox")
            {
                ApplicationArea = all;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if item.findset() then
            repeat
                rec := Item;
                //if item.GetCalcItemsAv() < 0 then
                    rec.Insert();
            until Item.Next() = 0;

        // CurrPage.PowerBIReportFactbox.PAGE.SetNameFilter(CurrPage.CAPTION);
        // CurrPage.PowerBIReportFactbox.PAGE.SetContext(CurrPage.OBJECTID(FALSE));
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ItemAvailability := rec.GetCalcItemsAv();

    end;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     CurrPage.PowerBIReportFactbox.PAGE.SetCurrentListSelection("No.", FALSE);
    // end;

    var
        Item: Record Item;
}