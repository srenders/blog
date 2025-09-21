page 90115 "Power BI Dataflows"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Power BI Dataflow";
    Caption = 'Power BI Dataflows';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(DataflowList)
            {
                field("Dataflow Name"; Rec."Dataflow Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The name of the Power BI dataflow';
                }
                field("Workspace Name"; GetWorkspaceName())
                {
                    ApplicationArea = All;
                    Caption = 'Workspace Name';
                    ToolTip = 'The name of the Power BI workspace containing this dataflow';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the dataflow';
                }
                field("Configured By"; Rec."Configured By")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who configured the dataflow';
                }
                field("Last Refresh"; Rec."Last Refresh")
                {
                    ApplicationArea = All;
                    ToolTip = 'When the dataflow was last refreshed';
                }
                field("Last Refresh Status"; Rec."Last Refresh Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the last refresh operation';
                }
                field("Last Refresh Duration (Min)"; Rec."Last Refresh Duration (Min)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Duration of the last refresh in minutes';
                }
                field("Average Refresh Duration (Min)"; Rec."Average Refresh Duration (Min)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Average duration of refresh operations in minutes';
                }
                field("Refresh Count"; Rec."Refresh Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of refresh operations tracked';
                }
                field("Last Synchronized"; Rec."Last Synchronized")
                {
                    ApplicationArea = All;
                    ToolTip = 'When this dataflow information was last synchronized from Power BI';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SynchronizeDataflows)
            {
                ApplicationArea = All;
                Caption = 'Sync All Dataflows from Power BI';
                Image = Refresh;
                ToolTip = 'Synchronize all dataflows from Power BI across all workspaces.';

                trigger OnAction()
                var
                    PowerBIAPIManagement: Codeunit "Power BI API Management";
                begin
                    if Confirm('Do you want to synchronize all dataflows from Power BI? This may take a moment.', false) then begin
                        PowerBIAPIManagement.SynchronizeAllData();
                        CurrPage.Update(false);
                        Message('Dataflow synchronization completed.');
                    end;
                end;
            }

            action(SynchronizeWorkspaceDataflows)
            {
                ApplicationArea = All;
                Caption = 'Sync Dataflows for This Workspace';
                Image = RefreshLines;
                ToolTip = 'Synchronize dataflows from Power BI for the selected workspace only.';

                trigger OnAction()
                var
                    PowerBIAPIManagement: Codeunit "Power BI API Management";
                begin
                    if Rec."Workspace ID" <> '' then begin
                        if Confirm('Do you want to synchronize dataflows for workspace "%1"?', false, GetWorkspaceName()) then begin
                            PowerBIAPIManagement.SynchronizeDataflows(Rec."Workspace ID");
                            CurrPage.Update(false);
                            Message('Dataflow synchronization completed for workspace: %1', GetWorkspaceName());
                        end;
                    end else
                        Message('No workspace selected.');
                end;
            }

            action(RefreshDataflow)
            {
                ApplicationArea = All;
                Caption = 'Refresh This Dataflow';
                Image = RefreshText;
                ToolTip = 'Trigger a refresh for the selected dataflow in Power BI.';

                trigger OnAction()
                var
                    PowerBIAPI: Codeunit "Power BI API Management";
                begin
                    if Confirm('Do you want to trigger a refresh for dataflow %1?', false, Rec."Dataflow Name") then
                        if PowerBIAPI.TriggerDataflowRefresh(Rec."Workspace ID", Rec."Dataflow ID") then begin
                            Message('Refresh successfully triggered for dataflow: %1', Rec."Dataflow Name");
                            CurrPage.Update(false);
                        end else
                            Message('Failed to trigger refresh for dataflow: %1', Rec."Dataflow Name");
                end;
            }

            action(GetRefreshHistory)
            {
                Caption = 'Get Dataflow Refresh History';
                ApplicationArea = All;
                Image = UpdateDescription;
                ToolTip = 'Get the latest refresh history for the selected dataflow.';

                trigger OnAction()
                var
                    PowerBIAPI: Codeunit "Power BI API Management";
                begin
                    if PowerBIAPI.GetDataflowRefreshHistory(Rec."Workspace ID", Rec."Dataflow ID") then begin
                        CurrPage.Update(false);
                        Message('Refresh history updated for dataflow: %1', Rec."Dataflow Name");
                    end else
                        Message('Failed to get refresh history for dataflow: %1', Rec."Dataflow Name");
                end;
            }
        }

        area(navigation)
        {
            action(OpenInPowerBI)
            {
                ApplicationArea = All;
                Caption = 'Open in Power BI';
                Image = Web;
                ToolTip = 'Open this dataflow in the Power BI portal.';

                trigger OnAction()
                begin
                    if Rec."Web URL" <> '' then
                        HyperLink(Rec."Web URL")
                    else
                        Message('Web URL not available for this dataflow.');
                end;
            }
        }
    }

    local procedure GetWorkspaceName(): Text
    var
        PowerBIWorkspace: Record "Power BI Workspace";
    begin
        if PowerBIWorkspace.Get(Rec."Workspace ID") then
            exit(PowerBIWorkspace."Workspace Name");
        exit('');
    end;
}