page 90127 "Power BI Dataflows Overview"
{
    Caption = 'Dataflows Overview';
    PageType = ListPart;
    SourceTable = "Power BI Dataflow";
    Editable = false;
    SourceTableView = sorting("Dataflow Name");

    layout
    {
        area(Content)
        {
            repeater(Dataflows)
            {
                field("Dataflow Name"; Rec."Dataflow Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the Power BI dataflow';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Power BI Dataflows", Rec);
                    end;
                }

                field("Workspace Name"; GetWorkspaceName())
                {
                    ApplicationArea = All;
                    Caption = 'Workspace';
                    ToolTip = 'Workspace containing this dataflow';
                }

                field("Last Refresh Status"; Rec."Last Refresh Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the last refresh operation';
                    StyleExpr = StatusStyle;
                }

                field("Last Refresh"; Rec."Last Refresh")
                {
                    ApplicationArea = All;
                    ToolTip = 'When the dataflow was last refreshed';
                }

                field("Last Refresh Duration (Min)"; Rec."Last Refresh Duration (Min)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Duration of the last refresh in minutes';
                }

                field("Configured By"; Rec."Configured By")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who configured the dataflow';
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
                ToolTip = 'Refresh the dataflow overview';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }

            action(ViewDetails)
            {
                ApplicationArea = All;
                Caption = 'View All Dataflows';
                Image = View;
                ToolTip = 'Open the full dataflows page';

                trigger OnAction()
                begin
                    Page.Run(Page::"Power BI Dataflows");
                end;
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        StatusStyle := GetStatusStyle();
    end;

    local procedure GetWorkspaceName(): Text
    var
        PowerBIWorkspace: Record "Power BI Workspace";
    begin
        if PowerBIWorkspace.Get(Rec."Workspace ID") then
            exit(PowerBIWorkspace."Workspace Name");
        exit('');
    end;

    local procedure GetStatusStyle(): Text
    begin
        case LowerCase(Rec."Last Refresh Status") of
            'completed':
                exit('Favorable');
            'failed':
                exit('Unfavorable');
            'cancelled':
                exit('Ambiguous');
            else
                exit('Standard');
        end;
    end;
}