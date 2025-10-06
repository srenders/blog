page 90128 "Power BI Overview"
{
    Caption = 'Power BI Overview';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Power BI Workspace";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Summary)
            {
                Caption = 'Summary';

                field(TotalWorkspaces; GetTotalWorkspaces())
                {
                    ApplicationArea = All;
                    Caption = 'Total Workspaces';
                    ToolTip = 'Total number of Power BI workspaces';
                    Editable = false;
                    StyleExpr = 'Strong';
                }

                field(TotalDatasets; GetTotalDatasets())
                {
                    ApplicationArea = All;
                    Caption = 'Total Datasets';
                    ToolTip = 'Total number of Power BI datasets';
                    Editable = false;
                    StyleExpr = 'Strong';
                }

                field(TotalDataflows; GetTotalDataflows())
                {
                    ApplicationArea = All;
                    Caption = 'Total Dataflows';
                    ToolTip = 'Total number of Power BI dataflows';
                    Editable = false;
                    StyleExpr = 'Strong';
                }

                field(LastSyncTime; GetLastSyncTime())
                {
                    ApplicationArea = All;
                    Caption = 'Last Synchronization';
                    ToolTip = 'When data was last synchronized from Power BI';
                    Editable = false;
                }
            }

            part(WorkspacesPart; "Power BI Workspaces Overview")
            {
                ApplicationArea = All;
                Caption = 'Workspaces';
            }

            part(DatasetsPart; "Power BI Datasets Overview")
            {
                ApplicationArea = All;
                Caption = 'Datasets';
            }

            part(DataflowsPart; "Power BI Dataflows Overview")
            {
                ApplicationArea = All;
                Caption = 'Dataflows';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Synchronization)
            {
                Caption = 'Synchronization';

                action(SyncAllData)
                {
                    ApplicationArea = All;
                    Caption = 'Sync All Data';
                    Image = Refresh;
                    ToolTip = 'Synchronize all Power BI data (workspaces, datasets, dataflows, reports)';

                    trigger OnAction()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if Confirm('Do you want to synchronize all Power BI data? This may take a few minutes.', false) then begin
                            if PowerBIAPIOrchestrator.SynchronizeAllData() then
                                Message('All Power BI data synchronized successfully.')
                            else
                                Message('Synchronization completed with some errors. Check individual items for details.');

                            CurrPage.Update(false);
                        end;
                    end;
                }

                action(SyncWorkspaces)
                {
                    ApplicationArea = All;
                    Caption = 'Sync Workspaces';
                    Image = RefreshLines;
                    ToolTip = 'Synchronize Power BI workspaces only';

                    trigger OnAction()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if PowerBIAPIOrchestrator.SynchronizeWorkspaces() then begin
                            Message('Workspaces synchronized successfully.');
                            CurrPage.Update(false);
                        end else
                            Message('Failed to synchronize workspaces.');
                    end;
                }
            }

            group(NavigationActions)
            {
                Caption = 'Navigation';

                action(OpenWorkspaces)
                {
                    ApplicationArea = All;
                    Caption = 'Manage Workspaces';
                    Image = Warehouse;
                    ToolTip = 'Open the full workspaces management page';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Power BI Workspaces");
                    end;
                }

                action(OpenDatasets)
                {
                    ApplicationArea = All;
                    Caption = 'Manage Datasets';
                    Image = Database;
                    ToolTip = 'Open the full datasets management page';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Power BI Datasets");
                    end;
                }

                action(OpenDataflows)
                {
                    ApplicationArea = All;
                    Caption = 'Manage Dataflows';
                    Image = Flow;
                    ToolTip = 'Open the full dataflows management page';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Power BI Dataflows");
                    end;
                }

                action(OpenReports)
                {
                    ApplicationArea = All;
                    Caption = 'Manage Reports';
                    Image = Report;
                    ToolTip = 'Open the reports management page';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Power BI Reports");
                    end;
                }
            }

            group(Monitoring)
            {
                Caption = 'Monitoring';

                action(RefreshErrors)
                {
                    ApplicationArea = All;
                    Caption = 'Refresh Errors';
                    Image = ErrorLog;
                    ToolTip = 'View comprehensive overview of Power BI refresh errors';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Power BI Refresh Errors");
                    end;
                }
            }

            group(Configuration)
            {
                Caption = 'Configuration';

                action(OpenSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Power BI Setup';
                    Image = Setup;
                    ToolTip = 'Configure Power BI connection and authentication settings';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Power BI Setup");
                    end;
                }

                action(TestConnection)
                {
                    ApplicationArea = All;
                    Caption = 'Test Connection';
                    Image = TestDatabase;
                    ToolTip = 'Test the connection to Power BI with current settings';

                    trigger OnAction()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if PowerBIAPIOrchestrator.SynchronizeWorkspaces() then
                            Message('Connection test successful!')
                        else
                            Message('Connection test failed. Please check your configuration.');
                    end;
                }
            }
        }
    }

    local procedure GetTotalWorkspaces(): Integer
    var
        PowerBIWorkspace: Record "Power BI Workspace";
    begin
        exit(PowerBIWorkspace.Count());
    end;

    local procedure GetTotalDatasets(): Integer
    var
        PowerBIDataset: Record "Power BI Dataset";
    begin
        exit(PowerBIDataset.Count());
    end;

    local procedure GetTotalDataflows(): Integer
    var
        PowerBIDataflow: Record "Power BI Dataflow";
    begin
        exit(PowerBIDataflow.Count());
    end;

    local procedure GetLastSyncTime(): DateTime
    var
        PowerBIWorkspace: Record "Power BI Workspace";
        LatestSync: DateTime;
    begin
        PowerBIWorkspace.SetCurrentKey("Last Synchronized");
        PowerBIWorkspace.SetAscending("Last Synchronized", false);
        if PowerBIWorkspace.FindFirst() then
            LatestSync := PowerBIWorkspace."Last Synchronized";

        // Also check setup for auto sync time
        // Return the most recent sync time found
        exit(LatestSync);
    end;
}