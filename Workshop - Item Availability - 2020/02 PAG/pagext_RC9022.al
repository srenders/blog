pageextension 50122 PagExtItemAvailabilityCue extends "Business Manager Role Center"
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
