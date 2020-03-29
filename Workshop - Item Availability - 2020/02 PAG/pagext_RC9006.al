pageextension 50124 PagExtItemAvailabilityCue2 extends "Order Processor Role Center"
{
    layout
    {
        addlast(RoleCenter)
        {
            part(ItemCuePart; ItemCuePart)
            {
                ApplicationArea = all;
            }
            part("Power BI Report Spinner Part"; "Power BI Report Spinner Part")
            {
                ApplicationArea = all;
            }
        }
    }
}
