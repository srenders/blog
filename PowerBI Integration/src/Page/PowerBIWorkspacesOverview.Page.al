page 90125 "Power BI Workspaces Overview"
{
    Caption = 'Workspaces Overview';
    PageType = ListPart;
    SourceTable = "Power BI Workspace";
    Editable = false;
    SourceTableView = sorting("Workspace Name");

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

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Power BI Workspaces", Rec);
                    end;
                }

                field("Workspace Type"; Rec."Workspace Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Type of the Power BI workspace';
                }

                field("Dataset Count"; GetDatasetCount())
                {
                    ApplicationArea = All;
                    Caption = 'Datasets';
                    ToolTip = 'Number of datasets in this workspace';
                }

                field("Dataflow Count"; GetDataflowCount())
                {
                    ApplicationArea = All;
                    Caption = 'Dataflows';
                    ToolTip = 'Number of dataflows in this workspace';
                }

                field("Report Count"; GetReportCount())
                {
                    ApplicationArea = All;
                    Caption = 'Reports';
                    ToolTip = 'Number of reports in this workspace';
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
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh Overview Data';
                Image = Refresh;
                ToolTip = 'Refresh the workspace overview';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }

            action(ViewDetails)
            {
                ApplicationArea = All;
                Caption = 'View All Workspaces';
                Image = View;
                ToolTip = 'Open the full workspaces page';

                trigger OnAction()
                begin
                    Page.Run(Page::"Power BI Workspaces");
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
}