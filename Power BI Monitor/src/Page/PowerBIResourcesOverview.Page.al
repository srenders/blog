page 90130 "Power BI Resources Overview"
{
    Caption = 'Power BI Resources Overview';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Power BI Workspace";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Workspaces)
            {
                field("Workspace Name"; Rec."Workspace Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the Power BI workspace';
                    StyleExpr = 'Strong';
                }

                field("Workspace Type"; Rec."Workspace Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of the Power BI workspace';
                }

                field("Dataset Count"; GetDatasetCount())
                {
                    ApplicationArea = All;
                    Caption = 'Datasets';
                    ToolTip = 'Number of datasets in this workspace';

                    trigger OnDrillDown()
                    var
                        PowerBIDataset: Record "Power BI Dataset";
                    begin
                        PowerBIDataset.SetRange("Workspace ID", Rec."Workspace ID");
                        Page.Run(Page::"Power BI Datasets", PowerBIDataset);
                    end;
                }

                field("Dataflow Count"; GetDataflowCount())
                {
                    ApplicationArea = All;
                    Caption = 'Dataflows';
                    ToolTip = 'Number of dataflows in this workspace';

                    trigger OnDrillDown()
                    var
                        PowerBIDataflow: Record "Power BI Dataflow";
                    begin
                        PowerBIDataflow.SetRange("Workspace ID", Rec."Workspace ID");
                        Page.Run(Page::"Power BI Dataflows", PowerBIDataflow);
                    end;
                }

                field("Report Count"; GetReportCount())
                {
                    ApplicationArea = All;
                    Caption = 'Reports';
                    ToolTip = 'Number of reports in this workspace';

                    trigger OnDrillDown()
                    var
                        PowerBIReport: Record "Power BI Report";
                    begin
                        PowerBIReport.SetRange("Workspace ID", Rec."Workspace ID");
                        Page.Run(Page::"Power BI Reports", PowerBIReport);
                    end;
                }

                field("Failed Refreshes"; GetFailedRefreshCount())
                {
                    ApplicationArea = All;
                    Caption = 'Failed Refreshes';
                    ToolTip = 'Number of datasets/dataflows with failed refreshes in this workspace';
                }

                field("Is Read Only"; Rec."Is Read Only")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if this workspace is read-only';
                }

                field("Last Synchronized"; Rec."Last Synchronized")
                {
                    ApplicationArea = All;
                    ToolTip = 'When this workspace was last synchronized';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SyncWorkspace)
            {
                ApplicationArea = All;
                Caption = 'Sync Workspace';
                Image = RefreshLines;
                ToolTip = 'Synchronize the selected workspace and its contents';

                trigger OnAction()
                var
                    PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                begin
                    if PowerBIAPIOrchestrator.SynchronizeDatasets(Rec."Workspace ID") and
                       PowerBIAPIOrchestrator.SynchronizeDataflows(Rec."Workspace ID") then begin
                        Message('Workspace %1 synchronized successfully.', Rec."Workspace Name");
                        CurrPage.Update(false);
                    end else
                        Message('Failed to synchronize workspace %1. Please check error logs for details.', Rec."Workspace Name");
                end;
            }

            action(SyncAllWorkspaces)
            {
                ApplicationArea = All;
                Caption = 'Sync All Workspaces';
                Image = Refresh;
                ToolTip = 'Synchronize all workspaces and their contents';

                trigger OnAction()
                var
                    PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                begin
                    if Confirm('Do you want to synchronize all Power BI workspaces? This may take a few minutes.', false) then
                        if PowerBIAPIOrchestrator.SynchronizeAllData() then begin
                            Message('All workspaces synchronized successfully.');
                            CurrPage.Update(false);
                        end else
                            Message('Synchronization completed with some errors. Please check error logs for details.');
                end;
            }
        }
    }

    local procedure GetDatasetCount(): Integer
    var
        PowerBIDataset: Record "Power BI Dataset";
    begin
        PowerBIDataset.SetRange("Workspace ID", Rec."Workspace ID");
        exit(PowerBIDataset.Count());
    end;

    local procedure GetDataflowCount(): Integer
    var
        PowerBIDataflow: Record "Power BI Dataflow";
    begin
        PowerBIDataflow.SetRange("Workspace ID", Rec."Workspace ID");
        exit(PowerBIDataflow.Count());
    end;

    local procedure GetReportCount(): Integer
    var
        PowerBIReport: Record "Power BI Report";
    begin
        PowerBIReport.SetRange("Workspace ID", Rec."Workspace ID");
        exit(PowerBIReport.Count());
    end;

    local procedure GetFailedRefreshCount(): Integer
    var
        PowerBIDataset: Record "Power BI Dataset";
        PowerBIDataflow: Record "Power BI Dataflow";
        FailedCount: Integer;
    begin
        PowerBIDataset.SetRange("Workspace ID", Rec."Workspace ID");
        PowerBIDataset.SetFilter("Last Refresh Status", '*Failed*|*Error*');
        FailedCount += PowerBIDataset.Count();

        PowerBIDataflow.SetRange("Workspace ID", Rec."Workspace ID");
        PowerBIDataflow.SetFilter("Last Refresh Status", '*Failed*|*Error*');
        FailedCount += PowerBIDataflow.Count();

        exit(FailedCount);
    end;
}