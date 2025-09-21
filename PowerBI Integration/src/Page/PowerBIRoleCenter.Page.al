page 90120 "Power BI Role Center"
{
    Caption = 'Power BI Management';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {
            // Left Column
            group(Control1900724808)
            {
                ShowCaption = false;
                part(PowerBIActivities; "Power BI Activities")
                {
                    ApplicationArea = All;
                }
            }

            // Right Column
            group(Control1900724608)
            {
                ShowCaption = false;
                part(WorkspacesOverview; "Power BI Workspaces Overview")
                {
                    ApplicationArea = All;
                }
                part(DatasetsOverview; "Power BI Datasets Overview")
                {
                    ApplicationArea = All;
                }
                part(DataflowsOverview; "Power BI Dataflows Overview")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(PowerBI)
            {
                Caption = 'Power BI';
                Image = Setup;

                action(PowerBISetup)
                {
                    ApplicationArea = All;
                    Caption = 'Power BI Setup';
                    Image = Setup;
                    RunObject = Page "Power BI Setup";
                    ToolTip = 'Configure Power BI connection settings including Azure AD authentication.';
                }
                action(PowerBIOverview)
                {
                    ApplicationArea = All;
                    Caption = 'Power BI Overview';
                    Image = View;
                    RunObject = Page "Power BI Overview";
                    ToolTip = 'Comprehensive overview of all Power BI workspaces, datasets, and dataflows.';
                }
                action(PowerBIResources)
                {
                    ApplicationArea = All;
                    Caption = 'Power BI Resources';
                    Image = Worksheet;
                    RunObject = Page "Power BI Resources Overview";
                    ToolTip = 'Integrated view of all Power BI resources by workspace.';
                }
                action(PowerBIWorkspaces)
                {
                    ApplicationArea = All;
                    Caption = 'Workspaces';
                    Image = Warehouse;
                    RunObject = Page "Power BI Workspaces";
                    ToolTip = 'View and manage Power BI workspaces.';
                }
                action(PowerBIDatasets)
                {
                    ApplicationArea = All;
                    Caption = 'Datasets';
                    Image = Database;
                    RunObject = Page "Power BI Datasets";
                    ToolTip = 'View and manage Power BI datasets with refresh history.';
                }
                action(PowerBIDataflows)
                {
                    ApplicationArea = All;
                    Caption = 'Dataflows';
                    Image = Flow;
                    RunObject = Page "Power BI Dataflows";
                    ToolTip = 'View and manage Power BI dataflows with refresh monitoring.';
                }
                action(PowerBIReports)
                {
                    ApplicationArea = All;
                    Caption = 'Reports';
                    Image = Report;
                    RunObject = Page "Power BI Reports";
                    ToolTip = 'View and manage Power BI reports and their settings.';
                }
            }
        }
        area(Creation)
        {
            action(SyncAllData)
            {
                ApplicationArea = All;
                Caption = 'Sync All Data';
                Image = Refresh;
                ToolTip = 'Synchronize all Power BI data (workspaces, datasets, dataflows, reports)';
                RunObject = Page "Power BI Setup";
            }
        }
        area(Processing)
        {
            action(TestConnection)
            {
                ApplicationArea = All;
                Caption = 'Test Connection';
                Image = TestDatabase;
                ToolTip = 'Test the connection to Power BI with current settings';
                RunObject = Page "Power BI Setup";
            }
        }
    }
}