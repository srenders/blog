page 90113 "Power BI Datasets"
{
    Caption = 'Power BI Datasets';
    PageType = List;
    SourceTable = "Power BI Dataset";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dataset ID"; Rec."Dataset ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier of the dataset.';
                }

                field("Dataset Name"; Rec."Dataset Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the dataset.';
                }

                field("Workspace ID"; Rec."Workspace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the workspace containing this dataset.';
                    Visible = false;
                }

                field("Is Refreshable"; Rec."Is Refreshable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the dataset can be refreshed.';
                }

                field("Last Refresh"; Rec."Last Refresh")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the dataset was last refreshed.';
                }

                field("Last Refresh Status"; Rec."Last Refresh Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the last refresh.';
                }

                field("Last Refresh Duration (Min)"; Rec."Last Refresh Duration (Min)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the last refresh in minutes.';
                }

                field("Average Refresh Duration (Min)"; Rec."Average Refresh Duration (Min)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the average refresh duration in minutes.';
                }

                field("Refresh Count"; Rec."Refresh Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of refresh operations tracked.';
                }

                field("Configured By"; Rec."Configured By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who configured the dataset.';
                }

                field("Last Synchronized"; Rec."Last Synchronized")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the dataset information was last synchronized.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RefreshDataset)
            {
                Caption = 'Refresh This Dataset';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Trigger a refresh of the selected dataset in Power BI.';
                Enabled = RefreshEnabled;

                trigger OnAction()
                var
                    PowerBIAPI: Codeunit "Power BI API Management";
                begin
                    if Confirm('Do you want to trigger a refresh for dataset %1?', false, Rec."Dataset Name") then
                        if PowerBIAPI.TriggerDatasetRefresh(Rec."Workspace ID", Rec."Dataset ID") then begin
                            Message('Refresh successfully triggered for dataset: %1', Rec."Dataset Name");
                            // Optionally refresh the page to get updated status
                            CurrPage.Update(false);
                        end else
                            Message('Failed to trigger refresh for dataset: %1', Rec."Dataset Name");
                end;
            }

            action(RefreshMultipleDatasets)
            {
                Caption = 'Refresh Selected Datasets';
                ApplicationArea = All;
                Image = RefreshLines;
                ToolTip = 'Trigger refresh for all selected datasets in Power BI.';

                trigger OnAction()
                var
                    PowerBIDataset: Record "Power BI Dataset";
                    PowerBIAPI: Codeunit "Power BI API Management";
                    SelectedCount: Integer;
                    SuccessCount: Integer;
                    FailedCount: Integer;
                    RefreshableCount: Integer;
                    ConfirmText: Text;
                begin
                    CurrPage.SetSelectionFilter(PowerBIDataset);
                    if PowerBIDataset.FindSet() then begin
                        repeat
                            SelectedCount += 1;
                            if PowerBIDataset."Is Refreshable" then
                                RefreshableCount += 1;
                        until PowerBIDataset.Next() = 0;

                        if RefreshableCount = 0 then begin
                            Message('None of the selected datasets are refreshable.');
                            exit;
                        end;

                        if SelectedCount = RefreshableCount then
                            ConfirmText := 'Do you want to trigger refresh for %1 selected datasets?'
                        else
                            ConfirmText := 'Do you want to trigger refresh for %2 refreshable datasets out of %1 selected?';

                        if Confirm(ConfirmText, false, SelectedCount, RefreshableCount) then begin
                            PowerBIDataset.Reset();
                            CurrPage.SetSelectionFilter(PowerBIDataset);
                            if PowerBIDataset.FindSet() then
                                repeat
                                    if PowerBIDataset."Is Refreshable" then
                                        if PowerBIAPI.TriggerDatasetRefresh(PowerBIDataset."Workspace ID", PowerBIDataset."Dataset ID") then
                                            SuccessCount += 1
                                        else
                                            FailedCount += 1;
                                until PowerBIDataset.Next() = 0;

                            // Show summary results
                            if FailedCount = 0 then
                                Message('Successfully triggered refresh for %1 dataset(s).', SuccessCount)
                            else
                                Message('Refresh triggered for %1 dataset(s). %2 failed to trigger.', SuccessCount, FailedCount);

                            CurrPage.Update(false);
                        end;
                    end else
                        Message('No datasets selected. Please select one or more datasets to refresh.');
                end;
            }

            action(RefreshAllDatasets)
            {
                Caption = 'Refresh All Datasets (Refreshable Only)';
                ApplicationArea = All;
                Image = RefreshText;
                ToolTip = 'Trigger refresh for all refreshable datasets in the current view.';

                trigger OnAction()
                var
                    PowerBIDataset: Record "Power BI Dataset";
                    PowerBIAPI: Codeunit "Power BI API Management";
                    TotalCount: Integer;
                    RefreshableCount: Integer;
                    SuccessCount: Integer;
                    FailedCount: Integer;
                begin
                    PowerBIDataset.CopyFilters(Rec);
                    if PowerBIDataset.FindSet() then begin
                        repeat
                            TotalCount += 1;
                            if PowerBIDataset."Is Refreshable" then
                                RefreshableCount += 1;
                        until PowerBIDataset.Next() = 0;

                        if RefreshableCount = 0 then begin
                            Message('No refreshable datasets found in the current view.');
                            exit;
                        end;

                        if Confirm('Do you want to trigger refresh for all %1 refreshable datasets? (Total datasets in view: %2)', false, RefreshableCount, TotalCount) then begin
                            PowerBIDataset.Reset();
                            PowerBIDataset.CopyFilters(Rec);
                            if PowerBIDataset.FindSet() then
                                repeat
                                    if PowerBIDataset."Is Refreshable" then
                                        if PowerBIAPI.TriggerDatasetRefresh(PowerBIDataset."Workspace ID", PowerBIDataset."Dataset ID") then
                                            SuccessCount += 1
                                        else
                                            FailedCount += 1;
                                until PowerBIDataset.Next() = 0;

                            // Show summary results
                            if FailedCount = 0 then
                                Message('Successfully triggered refresh for all %1 refreshable dataset(s).', SuccessCount)
                            else
                                Message('Refresh triggered for %1 dataset(s). %2 failed to trigger.', SuccessCount, FailedCount);

                            CurrPage.Update(false);
                        end;
                    end else
                        Message('No datasets found in the current view.');
                end;
            }

            action(GetRefreshHistory)
            {
                Caption = 'Get Dataset Refresh History';
                ApplicationArea = All;
                Image = UpdateDescription;
                ToolTip = 'Get the latest refresh history for the selected dataset.';

                trigger OnAction()
                var
                    PowerBIAPI: Codeunit "Power BI API Management";
                begin
                    if PowerBIAPI.GetDatasetRefreshHistory(Rec."Workspace ID", Rec."Dataset ID") then begin
                        CurrPage.Update(false);
                        Message('Refresh history updated for dataset: %1', Rec."Dataset Name");
                    end else
                        Message('Failed to get refresh history for dataset: %1', Rec."Dataset Name");
                end;
            }
        }

        area(navigation)
        {
            action(OpenInPowerBI)
            {
                Caption = 'Open in Power BI';
                ApplicationArea = All;
                Image = Web;
                ToolTip = 'Open this dataset in the Power BI portal.';

                trigger OnAction()
                begin
                    if Rec."Web URL" <> '' then
                        HyperLink(Rec."Web URL")
                    else
                        Message('Web URL not available for this dataset.');
                end;
            }
        }
    }

    var
        RefreshEnabled: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        RefreshEnabled := Rec."Is Refreshable";
    end;
}