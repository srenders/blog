page 90126 "Power BI Datasets Overview"
{
    Caption = 'Datasets Overview';
    PageType = ListPart;
    SourceTable = "Power BI Dataset";
    Editable = false;
    SourceTableView = sorting("Dataset Name");

    layout
    {
        area(Content)
        {
            repeater(Datasets)
            {
                field("Dataset Name"; Rec."Dataset Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the Power BI dataset';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Power BI Datasets", Rec);
                    end;
                }

                field("Workspace Name"; GetWorkspaceName())
                {
                    ApplicationArea = All;
                    Caption = 'Workspace';
                    ToolTip = 'Workspace containing this dataset';
                }

                field("Is Refreshable"; Rec."Is Refreshable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the dataset can be refreshed';
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
                    ToolTip = 'When the dataset was last refreshed';
                }

                field("Last Refresh Duration (Min)"; Rec."Last Refresh Duration (Min)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Duration of the last refresh in minutes';
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
                ToolTip = 'Refresh the dataset overview';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }

            action(ViewDetails)
            {
                ApplicationArea = All;
                Caption = 'View All Datasets';
                Image = View;
                ToolTip = 'Open the full datasets page';

                trigger OnAction()
                begin
                    Page.Run(Page::"Power BI Datasets");
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