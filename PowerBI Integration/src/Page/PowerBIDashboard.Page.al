page 90122 "Power BI Dashboard"
{
    Caption = 'Power BI Management Dashboard';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Overview)
            {
                Caption = 'Power BI Overview';

                group(Statistics)
                {
                    Caption = 'Statistics';

                    field(WorkspaceCount; WorkspaceCount)
                    {
                        ApplicationArea = All;
                        Caption = 'Total Workspaces';
                        ToolTip = 'Number of synchronized Power BI workspaces.';
                        Editable = false;
                        StyleExpr = 'Strong';
                    }

                    field(DatasetCount; DatasetCount)
                    {
                        ApplicationArea = All;
                        Caption = 'Total Datasets';
                        ToolTip = 'Number of synchronized Power BI datasets.';
                        Editable = false;
                        StyleExpr = 'Strong';
                    }

                    field(DataflowCount; DataflowCount)
                    {
                        ApplicationArea = All;
                        Caption = 'Total Dataflows';
                        ToolTip = 'Number of synchronized Power BI dataflows.';
                        Editable = false;
                        StyleExpr = 'Strong';
                    }
                }

                group(RefreshMetrics)
                {
                    Caption = 'Refresh Performance';

                    field(SuccessfulRefreshes; SuccessfulRefreshes)
                    {
                        ApplicationArea = All;
                        Caption = 'Successful Refreshes';
                        ToolTip = 'Number of datasets with successful last refresh.';
                        Editable = false;
                        StyleExpr = 'Favorable';
                    }

                    field(FailedRefreshes; FailedRefreshes)
                    {
                        ApplicationArea = All;
                        Caption = 'Failed Refreshes';
                        ToolTip = 'Number of datasets with failed last refresh.';
                        Editable = false;
                        StyleExpr = FailedRefreshesStyle;
                    }

                    field(AverageRefreshTime; AverageRefreshTime)
                    {
                        ApplicationArea = All;
                        Caption = 'Average Refresh Time (Minutes)';
                        ToolTip = 'Average refresh time across all datasets.';
                        Editable = false;
                        DecimalPlaces = 1;
                    }
                }

                group(LastSync)
                {
                    Caption = 'Last Synchronization';

                    field(LastSyncTime; LastSyncTime)
                    {
                        ApplicationArea = All;
                        Caption = 'Last Sync Time';
                        ToolTip = 'When the Power BI data was last synchronized.';
                        Editable = false;
                    }
                }
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

                action(SyncAll)
                {
                    ApplicationArea = All;
                    Caption = 'Synchronize All Power BI';
                    Image = Refresh;
                    ToolTip = 'Synchronize all Power BI workspaces, datasets, and dataflows.';

                    trigger OnAction()
                    var
                        PowerBIAPIManagement: Codeunit "Power BI API Management";
                    begin
                        if Confirm('This will synchronize all Power BI workspaces, datasets, and dataflows. Continue?') then begin
                            PowerBIAPIManagement.SynchronizeWorkspaces();
                            CalculateStatistics();
                            LastSyncTime := CurrentDateTime;
                            Message('Power BI synchronization completed successfully.');
                        end;
                    end;
                }

                action(SyncWorkspaces)
                {
                    ApplicationArea = All;
                    Caption = 'Sync Workspaces Only';
                    Image = Warehouse;
                    ToolTip = 'Synchronize Power BI workspaces only.';

                    trigger OnAction()
                    var
                        PowerBIAPIManagement: Codeunit "Power BI API Management";
                    begin
                        PowerBIAPIManagement.SynchronizeWorkspaces();
                        CalculateStatistics();
                        Message('Workspaces synchronized successfully.');
                    end;
                }
            }

            group(Management)
            {
                Caption = 'Management';

                action(OpenSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Power BI Setup';
                    Image = Setup;
                    RunObject = Page "Power BI Setup";
                    ToolTip = 'Configure Power BI connection settings.';
                }

                action(OpenWorkspaces)
                {
                    ApplicationArea = All;
                    Caption = 'View Workspaces';
                    Image = Warehouse;
                    RunObject = Page "Power BI Workspaces";
                    ToolTip = 'View and manage Power BI workspaces.';
                }

                action(OpenDatasets)
                {
                    ApplicationArea = All;
                    Caption = 'View Datasets';
                    Image = Database;
                    RunObject = Page "Power BI Datasets";
                    ToolTip = 'View and manage Power BI datasets.';
                }

                action(OpenDataflows)
                {
                    ApplicationArea = All;
                    Caption = 'View Dataflows';
                    Image = Flow;
                    RunObject = Page "Power BI Dataflows";
                    ToolTip = 'View and manage Power BI dataflows.';
                }
            }

            group(Analysis)
            {
                Caption = 'Analysis';

                action(ViewFailedRefreshes)
                {
                    ApplicationArea = All;
                    Caption = 'View Failed Refreshes';
                    Image = ErrorLog;
                    ToolTip = 'View datasets with failed refreshes.';

                    trigger OnAction()
                    var
                        PowerBIDataset: Record "Power BI Dataset";
                    begin
                        PowerBIDataset.SetRange("Last Refresh Status", 'Failed');
                        Page.Run(Page::"Power BI Datasets", PowerBIDataset);
                    end;
                }

                action(ViewPerformanceMetrics)
                {
                    ApplicationArea = All;
                    Caption = 'Performance Metrics';
                    Image = Report;
                    ToolTip = 'View refresh performance metrics.';

                    trigger OnAction()
                    var
                        PowerBIDataset: Record "Power BI Dataset";
                    begin
                        PowerBIDataset.SetFilter("Average Refresh Duration (Min)", '>0');
                        Page.Run(Page::"Power BI Datasets", PowerBIDataset);
                    end;
                }
            }
        }
    }

    var
        WorkspaceCount: Integer;
        DatasetCount: Integer;
        DataflowCount: Integer;
        SuccessfulRefreshes: Integer;
        FailedRefreshes: Integer;
        AverageRefreshTime: Decimal;
        LastSyncTime: DateTime;
        FailedRefreshesStyle: Text;

    trigger OnOpenPage()
    begin
        CalculateStatistics();
    end;

    local procedure CalculateStatistics()
    var
        PowerBIWorkspace: Record "Power BI Workspace";
        PowerBIDataset: Record "Power BI Dataset";
        PowerBIDataflow: Record "Power BI Dataflow";
        TotalRefreshTime: Decimal;
        DatasetWithTime: Integer;
    begin
        // Count workspaces
        WorkspaceCount := PowerBIWorkspace.Count();

        // Count datasets
        DatasetCount := PowerBIDataset.Count();

        // Count dataflows
        DataflowCount := PowerBIDataflow.Count();

        // Calculate refresh statistics
        SuccessfulRefreshes := 0;
        FailedRefreshes := 0;
        TotalRefreshTime := 0;
        DatasetWithTime := 0;

        if PowerBIDataset.FindSet() then
            repeat
                case PowerBIDataset."Last Refresh Status" of
                    'Completed':
                        SuccessfulRefreshes += 1;
                    'Failed':
                        FailedRefreshes += 1;
                end;

                if PowerBIDataset."Average Refresh Duration (Min)" > 0 then begin
                    TotalRefreshTime += PowerBIDataset."Average Refresh Duration (Min)";
                    DatasetWithTime += 1;
                end;
            until PowerBIDataset.Next() = 0;

        // Calculate average refresh time
        if DatasetWithTime > 0 then
            AverageRefreshTime := TotalRefreshTime / DatasetWithTime
        else
            AverageRefreshTime := 0;

        // Set style for failed refreshes
        if FailedRefreshes > 0 then
            FailedRefreshesStyle := 'Unfavorable'
        else
            FailedRefreshesStyle := 'Favorable';
    end;
}