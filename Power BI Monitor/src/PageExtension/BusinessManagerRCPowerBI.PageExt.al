pageextension 90120 "Business Manager RC Power BI" extends "Business Manager Role Center"
{
    layout
    {
        addlast(RoleCenter)
        {
            group(PowerBIManagement)
            {
                Caption = 'Power BI Management';
                part(PowerBIActivitiesPart; "Power BI Activities")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        addlast(Sections)
        {
            group(PowerBI)
            {
                Caption = 'Power BI';
                Image = Setup;

                action(PowerBIDashboard)
                {
                    ApplicationArea = All;
                    Caption = 'Power BI Dashboard';
                    Image = PowerBI;
                    RunObject = Page "Power BI Dashboard";
                    ToolTip = 'Open the Power BI management dashboard with comprehensive monitoring and synchronization capabilities.';
                }

                action(PowerBIRoleCenter)
                {
                    ApplicationArea = All;
                    Caption = 'Power BI Role Center';
                    Image = Home;
                    RunObject = Page "Power BI Role Center";
                    ToolTip = 'Open the dedicated Power BI Role Center for comprehensive Power BI management.';
                }

                action(PowerBISetup)
                {
                    ApplicationArea = All;
                    Caption = 'Power BI Setup';
                    Image = Setup;
                    RunObject = Page "Power BI Setup";
                    ToolTip = 'Configure Power BI connection settings including Azure AD authentication.';
                }
            }
        }
    }
}