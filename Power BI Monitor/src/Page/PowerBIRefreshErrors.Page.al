page 90145 "Power BI Refresh Errors"
{
    Caption = 'Power BI Refresh Errors';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(ErrorSummary)
            {
                Caption = 'Error Summary';

                field(TotalDatasetErrors; GetDatasetErrorCount())
                {
                    ApplicationArea = All;
                    Caption = 'Dataset Errors (Last 30 Days)';
                    ToolTip = 'Number of dataset refresh errors in the last 30 days';
                    Editable = false;
                    StyleExpr = 'Unfavorable';

                    trigger OnDrillDown()
                    begin
                        ShowDatasetErrors();
                    end;
                }

                field(TotalDataflowErrors; GetDataflowErrorCount())
                {
                    ApplicationArea = All;
                    Caption = 'Dataflow Errors (Last 30 Days)';
                    ToolTip = 'Number of dataflow refresh errors in the last 30 days';
                    Editable = false;
                    StyleExpr = 'Unfavorable';

                    trigger OnDrillDown()
                    begin
                        ShowDataflowErrors();
                    end;
                }

                field(LastErrorTime; GetLastErrorTime())
                {
                    ApplicationArea = All;
                    Caption = 'Most Recent Error';
                    ToolTip = 'When the most recent refresh error occurred';
                    Editable = false;
                }
            }

            group(RecentErrors)
            {
                Caption = 'Recent Errors (Last 7 Days)';

                part(RecentErrorsList; "Power BI Recent Errors List")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(ViewErrors)
            {
                Caption = 'View Errors';

                action(ViewAllDatasetErrors)
                {
                    ApplicationArea = All;
                    Caption = 'All Dataset Errors';
                    Image = Database;
                    ToolTip = 'View all dataset refresh errors';

                    trigger OnAction()
                    begin
                        ShowDatasetErrors();
                    end;
                }

                action(ViewAllDataflowErrors)
                {
                    ApplicationArea = All;
                    Caption = 'All Dataflow Errors';
                    Image = Flow;
                    ToolTip = 'View all dataflow refresh errors';

                    trigger OnAction()
                    begin
                        ShowDataflowErrors();
                    end;
                }
            }

            group(Navigate)
            {
                Caption = 'Navigate';

                action(OpenDatasets)
                {
                    ApplicationArea = All;
                    Caption = 'Manage Datasets';
                    Image = Database;
                    ToolTip = 'Open the datasets management page';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Power BI Datasets");
                    end;
                }

                action(OpenDataflows)
                {
                    ApplicationArea = All;
                    Caption = 'Manage Dataflows';
                    Image = Flow;
                    ToolTip = 'Open the dataflows management page';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Power BI Dataflows");
                    end;
                }
            }

            group(Refresh)
            {
                Caption = 'Refresh';

                action(RefreshData)
                {
                    ApplicationArea = All;
                    Caption = 'Refresh Error Data';
                    Image = Refresh;
                    ToolTip = 'Refresh the error information from Power BI';

                    trigger OnAction()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if Confirm('Do you want to refresh error data from Power BI? This will update refresh history for all datasets and dataflows.', false) then begin
                            if PowerBIAPIOrchestrator.RefreshAllRefreshHistory() then
                                Message('Error data refreshed successfully.')
                            else
                                Message('Error data refresh completed with some issues.');

                            CurrPage.Update(false);
                        end;
                    end;
                }
            }
        }
    }

    local procedure GetDatasetErrorCount(): Integer
    var
        DatasetRefreshHistory: Record "PBI Dataset Refresh History";
        CutoffDate: DateTime;
    begin
        CutoffDate := CreateDateTime(CalcDate('<-30D>', Today()), 0T);
        DatasetRefreshHistory.SetRange(Status, DatasetRefreshHistory.Status::Failed);
        DatasetRefreshHistory.SetFilter("Start Time", '>=%1', CutoffDate);
        exit(DatasetRefreshHistory.Count());
    end;

    local procedure GetDataflowErrorCount(): Integer
    var
        DataflowRefreshHistory: Record "PBI Dataflow Refresh History";
        CutoffDate: DateTime;
    begin
        CutoffDate := CreateDateTime(CalcDate('<-30D>', Today()), 0T);
        DataflowRefreshHistory.SetRange(Status, DataflowRefreshHistory.Status::Failed);
        DataflowRefreshHistory.SetFilter("Start Time", '>=%1', CutoffDate);
        exit(DataflowRefreshHistory.Count());
    end;

    local procedure GetLastErrorTime(): DateTime
    var
        DatasetRefreshHistory: Record "PBI Dataset Refresh History";
        DataflowRefreshHistory: Record "PBI Dataflow Refresh History";
        LastDatasetError: DateTime;
        LastDataflowError: DateTime;
    begin
        // Get last dataset error
        DatasetRefreshHistory.SetRange(Status, DatasetRefreshHistory.Status::Failed);
        DatasetRefreshHistory.SetCurrentKey("Start Time");
        DatasetRefreshHistory.SetAscending("Start Time", false);
        if DatasetRefreshHistory.FindFirst() then
            LastDatasetError := DatasetRefreshHistory."Start Time";

        // Get last dataflow error
        DataflowRefreshHistory.SetRange(Status, DataflowRefreshHistory.Status::Failed);
        DataflowRefreshHistory.SetCurrentKey("Start Time");
        DataflowRefreshHistory.SetAscending("Start Time", false);
        if DataflowRefreshHistory.FindFirst() then
            LastDataflowError := DataflowRefreshHistory."Start Time";

        // Return the most recent
        if LastDatasetError > LastDataflowError then
            exit(LastDatasetError)
        else
            exit(LastDataflowError);
    end;

    local procedure ShowDatasetErrors()
    var
        DatasetRefreshHistory: Record "PBI Dataset Refresh History";
        DatasetRefreshHistoryPage: Page "PBI Dataset Refresh History";
    begin
        DatasetRefreshHistory.SetRange(Status, DatasetRefreshHistory.Status::Failed);
        DatasetRefreshHistory.SetCurrentKey("Start Time");
        DatasetRefreshHistory.SetAscending("Start Time", false);
        DatasetRefreshHistoryPage.SetTableView(DatasetRefreshHistory);
        DatasetRefreshHistoryPage.Run();
    end;

    local procedure ShowDataflowErrors()
    var
        DataflowRefreshHistory: Record "PBI Dataflow Refresh History";
        DataflowRefreshHistoryPage: Page "PBI Dataflow Refresh History";
    begin
        DataflowRefreshHistory.SetRange(Status, DataflowRefreshHistory.Status::Failed);
        DataflowRefreshHistory.SetCurrentKey("Start Time");
        DataflowRefreshHistory.SetAscending("Start Time", false);
        DataflowRefreshHistoryPage.SetTableView(DataflowRefreshHistory);
        DataflowRefreshHistoryPage.Run();
    end;
}