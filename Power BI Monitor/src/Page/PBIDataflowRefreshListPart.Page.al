page 90143 "PBI Dataflow Refresh ListPart"
{
    Caption = 'Dataflow Refresh History';
    PageType = ListPart;
    SourceTable = "PBI Dataflow Refresh History";
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
                    RefreshHistory: Record "PBI Dataflow Refresh History";
                    RefreshHistoryPage: Page "PBI Dataflow Refresh History";
                begin
                    RefreshHistory.SetRange("Dataflow ID", Rec."Dataflow ID");
                    RefreshHistoryPage.SetTableView(RefreshHistory);
                    RefreshHistoryPage.Run();
                end;
            }

            action(RefreshData)
            {
                Caption = 'Refresh Data';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Refresh the dataflow refresh history data.';

                trigger OnAction()
                var
                    DataflowRec: Record "Power BI Dataflow";
                    PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                begin
                    if DataflowRec.Get(Rec."Dataflow ID") then
                        if PowerBIAPIOrchestrator.GetDataflowRefreshHistory(DataflowRec."Workspace ID", DataflowRec."Dataflow ID") then begin
                            CurrPage.Update(false);
                            Message('Refresh history updated for dataflow.');
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