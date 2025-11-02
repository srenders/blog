pageextension 70101 BCManRC extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
        addfirst(rolecenter)
        {  
            part(PowerBIReportPart; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Power BI Reports';
                SubPageView = where(Context = const('PBIReportsPart1'));
            }
            part(PowerBIReportPart2; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Power BI Reports';
                SubPageView = where(Context = const('PBIReportsPart2'));
            }
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
}