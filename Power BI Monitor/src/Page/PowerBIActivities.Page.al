page 90121 "Power BI Activities"
{
    Caption = 'Power BI Activities';
    PageType = CardPart;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            cuegroup(PowerBIStatus)
            {
                Caption = 'Power BI Status';

                field(WorkspaceCount; WorkspaceCount)
                {
                    ApplicationArea = All;
                    Caption = 'Workspaces';
                    ToolTip = 'Number of synchronized Power BI workspaces.';
                    DrillDownPageId = "Power BI Workspaces";
                }

                field(DatasetCount; DatasetCount)
                {
                    ApplicationArea = All;
                    Caption = 'Datasets';
                    ToolTip = 'Number of synchronized Power BI datasets.';
                    DrillDownPageId = "Power BI Datasets";
                }

                field(DataflowCount; DataflowCount)
                {
                    ApplicationArea = All;
                    Caption = 'Dataflows';
                    ToolTip = 'Number of synchronized Power BI dataflows.';
                    DrillDownPageId = "Power BI Dataflows";
                }
            }

            cuegroup(RefreshStatus)
            {
                Caption = 'Refresh Status';

                field(SuccessfulRefreshes; SuccessfulRefreshes)
                {
                    ApplicationArea = All;
                    Caption = 'Successful Refreshes';
                    ToolTip = 'Number of datasets with successful last refresh.';
                    StyleExpr = 'Favorable';
                }

                field(FailedRefreshes; FailedRefreshes)
                {
                    ApplicationArea = All;
                    Caption = 'Failed Refreshes';
                    ToolTip = 'Number of datasets with failed last refresh.';
                    StyleExpr = 'Unfavorable';
                }

                field(AverageRefreshTime; AverageRefreshTime)
                {
                    ApplicationArea = All;
                    Caption = 'Avg Refresh Time (Min)';
                    ToolTip = 'Average refresh time across all datasets.';
                    DecimalPlaces = 1;
                }
            }

            cuegroup(QuickActions)
            {
                Caption = 'Quick Actions';

                field(SyncWorkspaces; 'Synchronize All')
                {
                    ApplicationArea = All;
                    Caption = 'Synchronize All';
                    ToolTip = 'Synchronize all Power BI workspaces, datasets, and dataflows.';

                    trigger OnDrillDown()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if PowerBIAPIOrchestrator.SynchronizeAllData() then
                            Message('Power BI synchronization completed successfully.')
                        else
                            Message('Power BI synchronization completed with some errors.');
                        CurrPage.Update();
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

    trigger OnOpenPage()
    begin
        CalculateStatistics();
    end;

    trigger OnAfterGetRecord()
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
    end;
}