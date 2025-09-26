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
        area(processing)
        {
            group(Synchronization)
            {
                Caption = 'Synchronization';
                ToolTip = 'Actions for synchronizing dataflow information from Power BI';

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
                        EmptyGuid: Guid;
                    begin
                        if Rec."Workspace ID" <> EmptyGuid then begin
                            if Confirm('Do you want to synchronize dataflows for workspace "%1"?', false, GetWorkspaceName()) then begin
                                PowerBIAPIManagement.SynchronizeDataflows(Rec."Workspace ID");
                                CurrPage.Update(false);
                                Message('Dataflow synchronization completed for workspace: %1', GetWorkspaceName());
                            end;
                        end else
                            Message('No workspace selected.');
                    end;
                }
            }

            group(Refresh)
            {
                Caption = 'Refresh Operations';
                ToolTip = 'Actions for triggering dataflow refreshes in Power BI';

                action(RefreshDataflow)
                {
                    ApplicationArea = All;
                    Caption = 'Refresh This Dataflow';
                    Image = Refresh;
                    ToolTip = 'Trigger a refresh for the selected dataflow in Power BI.';

                    trigger OnAction()
                    var
                        PowerBIAPI: Codeunit "Power BI API Management";
                    begin
                        if Confirm('Do you want to trigger a refresh for dataflow "%1"?', false, Rec."Dataflow Name") then
                            if PowerBIAPI.TriggerDataflowRefresh(Rec."Workspace ID", Rec."Dataflow ID") then begin
                                Message('Refresh successfully triggered for dataflow: %1', Rec."Dataflow Name");
                                CurrPage.Update(false);
                            end else
                                Message('Failed to trigger refresh for dataflow: %1', Rec."Dataflow Name");
                    end;
                }

                action(RefreshMultipleDataflows)
                {
                    Caption = 'Refresh Selected Dataflows';
                    ApplicationArea = All;
                    Image = RefreshLines;
                    ToolTip = 'Trigger refresh for all selected dataflows in Power BI.';

                    trigger OnAction()
                    var
                        PowerBIDataflow: Record "Power BI Dataflow";
                        PowerBIAPI: Codeunit "Power BI API Management";
                        SelectedCount: Integer;
                        SuccessCount: Integer;
                        FailedCount: Integer;
                    begin
                        CurrPage.SetSelectionFilter(PowerBIDataflow);
                        if PowerBIDataflow.FindSet() then begin
                            repeat
                                SelectedCount += 1;
                            until PowerBIDataflow.Next() = 0;

                            if Confirm('Do you want to trigger refresh for %1 selected dataflow(s)?', false, SelectedCount) then begin
                                PowerBIDataflow.Reset();
                                CurrPage.SetSelectionFilter(PowerBIDataflow);
                                if PowerBIDataflow.FindSet() then
                                    repeat
                                        if PowerBIAPI.TriggerDataflowRefresh(PowerBIDataflow."Workspace ID", PowerBIDataflow."Dataflow ID") then
                                            SuccessCount += 1
                                        else
                                            FailedCount += 1;
                                    until PowerBIDataflow.Next() = 0;

                                // Show summary results
                                if FailedCount = 0 then
                                    Message('Successfully triggered refresh for %1 dataflow(s).', SuccessCount)
                                else
                                    Message('Refresh triggered for %1 dataflow(s). %2 failed to trigger.', SuccessCount, FailedCount);

                                CurrPage.Update(false);
                            end;
                        end else
                            Message('No dataflows selected. Please select one or more dataflows to refresh.');
                    end;
                }

                action(RefreshAllDataflows)
                {
                    Caption = 'Refresh All Dataflows in View';
                    ApplicationArea = All;
                    Image = RefreshText;
                    ToolTip = 'Trigger refresh for all dataflows in the current view.';

                    trigger OnAction()
                    var
                        PowerBIDataflow: Record "Power BI Dataflow";
                        PowerBIAPI: Codeunit "Power BI API Management";
                        TotalCount: Integer;
                        SuccessCount: Integer;
                        FailedCount: Integer;
                    begin
                        PowerBIDataflow.CopyFilters(Rec);
                        if PowerBIDataflow.FindSet() then begin
                            repeat
                                TotalCount += 1;
                            until PowerBIDataflow.Next() = 0;

                            if Confirm('Do you want to trigger refresh for all %1 dataflow(s) in the current view?', false, TotalCount) then begin
                                PowerBIDataflow.Reset();
                                PowerBIDataflow.CopyFilters(Rec);
                                if PowerBIDataflow.FindSet() then
                                    repeat
                                        if PowerBIAPI.TriggerDataflowRefresh(PowerBIDataflow."Workspace ID", PowerBIDataflow."Dataflow ID") then
                                            SuccessCount += 1
                                        else
                                            FailedCount += 1;
                                    until PowerBIDataflow.Next() = 0;

                                // Show summary results
                                if FailedCount = 0 then
                                    Message('Successfully triggered refresh for all %1 dataflow(s).', SuccessCount)
                                else
                                    Message('Refresh triggered for %1 dataflow(s). %2 failed to trigger.', SuccessCount, FailedCount);

                                CurrPage.Update(false);
                            end;
                        end else
                            Message('No dataflows found in the current view.');
                    end;
                }
            }

            group(RefreshHistory)
            {
                Caption = 'Refresh History';
                ToolTip = 'Actions for managing dataflow refresh history tracking';

                action(GetRefreshHistory)
                {
                    Caption = 'Update Refresh History';
                    ApplicationArea = All;
                    Image = UpdateDescription;
                    ToolTip = 'Get the latest refresh history for the selected dataflow from Power BI.';

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

                action(GetRefreshHistoryMultiple)
                {
                    Caption = 'Update Refresh History for Selected';
                    ApplicationArea = All;
                    Image = UpdateDescription;
                    ToolTip = 'Get refresh history for all selected dataflows from Power BI.';

                    trigger OnAction()
                    var
                        PowerBIDataflow: Record "Power BI Dataflow";
                        PowerBIAPI: Codeunit "Power BI API Management";
                        SelectedCount: Integer;
                        SuccessCount: Integer;
                        FailedCount: Integer;
                    begin
                        CurrPage.SetSelectionFilter(PowerBIDataflow);
                        if PowerBIDataflow.FindSet() then begin
                            repeat
                                SelectedCount += 1;
                            until PowerBIDataflow.Next() = 0;

                            if Confirm('Do you want to update refresh history for %1 selected dataflow(s)?', false, SelectedCount) then begin
                                PowerBIDataflow.Reset();
                                CurrPage.SetSelectionFilter(PowerBIDataflow);
                                if PowerBIDataflow.FindSet() then
                                    repeat
                                        if PowerBIAPI.GetDataflowRefreshHistory(PowerBIDataflow."Workspace ID", PowerBIDataflow."Dataflow ID") then
                                            SuccessCount += 1
                                        else
                                            FailedCount += 1;
                                    until PowerBIDataflow.Next() = 0;

                                // Show summary results
                                if FailedCount = 0 then
                                    Message('Successfully updated refresh history for %1 dataflow(s).', SuccessCount)
                                else
                                    Message('Refresh history updated for %1 dataflow(s). %2 failed to update.', SuccessCount, FailedCount);

                                CurrPage.Update(false);
                            end;
                        end else
                            Message('No dataflows selected. Please select one or more dataflows.');
                    end;
                }

                action(GetRefreshHistoryAll)
                {
                    Caption = 'Update Refresh History for All';
                    ApplicationArea = All;
                    Image = UpdateDescription;
                    ToolTip = 'Get refresh history for all dataflows in the current view from Power BI.';

                    trigger OnAction()
                    var
                        PowerBIDataflow: Record "Power BI Dataflow";
                        PowerBIAPI: Codeunit "Power BI API Management";
                        TotalCount: Integer;
                        SuccessCount: Integer;
                        FailedCount: Integer;
                    begin
                        PowerBIDataflow.CopyFilters(Rec);
                        if PowerBIDataflow.FindSet() then begin
                            repeat
                                TotalCount += 1;
                            until PowerBIDataflow.Next() = 0;

                            if Confirm('Do you want to update refresh history for all %1 dataflow(s) in the current view?', false, TotalCount) then begin
                                PowerBIDataflow.Reset();
                                PowerBIDataflow.CopyFilters(Rec);
                                if PowerBIDataflow.FindSet() then
                                    repeat
                                        if PowerBIAPI.GetDataflowRefreshHistory(PowerBIDataflow."Workspace ID", PowerBIDataflow."Dataflow ID") then
                                            SuccessCount += 1
                                        else
                                            FailedCount += 1;
                                    until PowerBIDataflow.Next() = 0;

                                // Show summary results
                                if FailedCount = 0 then
                                    Message('Successfully updated refresh history for all %1 dataflow(s).', SuccessCount)
                                else
                                    Message('Refresh history updated for %1 dataflow(s). %2 failed to update.', SuccessCount, FailedCount);

                                CurrPage.Update(false);
                            end;
                        end else
                            Message('No dataflows found in the current view.');
                    end;
                }
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

            action(ViewRefreshHistory)
            {
                Caption = 'View Refresh History';
                ApplicationArea = All;
                Image = History;
                ToolTip = 'View detailed refresh history for this dataflow.';

                trigger OnAction()
                var
                    RefreshHistory: Record "PBI Dataflow Refresh History";
                    RefreshHistoryPage: Page "PBI Dataflow Refresh History";
                begin
                    RefreshHistory.SetRange("Dataflow ID", Format(Rec."Dataflow ID"));
                    RefreshHistoryPage.SetTableView(RefreshHistory);
                    RefreshHistoryPage.Run();
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