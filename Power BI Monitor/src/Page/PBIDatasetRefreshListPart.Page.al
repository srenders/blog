page 90142 "PBI Dataset Refresh ListPart"
{
    Caption = 'Dataset Refresh History';
    PageType = ListPart;
    SourceTable = "PBI Dataset Refresh History";
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(RefreshHistory)
            {
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the refresh started.';
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the refresh.';
                    Style = Favorable;
                    StyleExpr = StatusStyleExpr;
                }

                field("Duration (Minutes)"; Rec."Duration (Minutes)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the refresh in minutes.';
                }

                field("Refresh Type"; Rec."Refresh Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of refresh.';
                }

                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the refresh ended.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ViewDetails)
            {
                Caption = 'View Details';
                ApplicationArea = All;
                Image = View;
                ToolTip = 'View detailed refresh history information.';

                trigger OnAction()
                var
                    RefreshHistory: Record "PBI Dataset Refresh History";
                    RefreshHistoryPage: Page "PBI Dataset Refresh History";
                begin
                    RefreshHistory.SetRange("Dataset ID", Rec."Dataset ID");
                    RefreshHistoryPage.SetTableView(RefreshHistory);
                    RefreshHistoryPage.Run();
                end;
            }

            action(RefreshData)
            {
                Caption = 'Refresh Data';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Refresh the dataset refresh history data.';

                trigger OnAction()
                var
                    DatasetRec: Record "Power BI Dataset";
                    PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                begin
                    if DatasetRec.Get(Rec."Dataset ID") then
                        if PowerBIAPIOrchestrator.GetDatasetRefreshHistory(DatasetRec."Workspace ID", DatasetRec."Dataset ID") then begin
                            CurrPage.Update(false);
                            Message('Refresh history updated for dataset.');
                        end else
                            Message('Failed to update refresh history.');
                end;
            }
        }
    }

    var
        StatusStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        // Set styling based on status
        StatusStyleExpr := 'None';
        case Rec."Status" of
            Rec."Status"::Completed:
                StatusStyleExpr := 'Favorable';
            Rec."Status"::Failed:
                StatusStyleExpr := 'Unfavorable';
            Rec."Status"::"In Progress":
                StatusStyleExpr := 'Ambiguous';
            else
                StatusStyleExpr := 'None';
        end;
    end;
}