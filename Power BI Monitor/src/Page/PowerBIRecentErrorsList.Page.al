page 90146 "Power BI Recent Errors List"
{
    Caption = 'Recent Refresh Errors';
    PageType = CardPart;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            group(RecentErrorsInfo)
            {
                Caption = 'Recent Errors (Last 7 Days)';
                ShowCaption = false;

                field(RecentDatasetErrors; GetRecentDatasetErrors())
                {
                    ApplicationArea = All;
                    Caption = 'Dataset Errors';
                    ToolTip = 'Number of dataset refresh errors in the last 7 days';
                    Editable = false;
                    StyleExpr = 'Unfavorable';

                    trigger OnDrillDown()
                    begin
                        ShowRecentDatasetErrors();
                    end;
                }

                field(RecentDataflowErrors; GetRecentDataflowErrors())
                {
                    ApplicationArea = All;
                    Caption = 'Dataflow Errors';
                    ToolTip = 'Number of dataflow refresh errors in the last 7 days';
                    Editable = false;
                    StyleExpr = 'Unfavorable';

                    trigger OnDrillDown()
                    begin
                        ShowRecentDataflowErrors();
                    end;
                }

                field(LastErrorInfo; GetLastErrorInfo())
                {
                    ApplicationArea = All;
                    Caption = 'Most Recent Error';
                    ToolTip = 'Information about the most recent refresh error';
                    Editable = false;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ViewAllErrors)
            {
                ApplicationArea = All;
                Caption = 'View All Errors';
                Image = View;
                ToolTip = 'Open the full error overview page';

                trigger OnAction()
                begin
                    Page.Run(Page::"Power BI Refresh Errors");
                end;
            }
        }
    }

    local procedure GetRecentDatasetErrors(): Integer
    var
        DatasetRefreshHistory: Record "PBI Dataset Refresh History";
        CutoffDate: DateTime;
    begin
        CutoffDate := CreateDateTime(CalcDate('<-7D>', Today()), 0T);
        DatasetRefreshHistory.SetRange(Status, DatasetRefreshHistory.Status::Failed);
        DatasetRefreshHistory.SetFilter("Start Time", '>=%1', CutoffDate);
        exit(DatasetRefreshHistory.Count());
    end;

    local procedure GetRecentDataflowErrors(): Integer
    var
        DataflowRefreshHistory: Record "PBI Dataflow Refresh History";
        CutoffDate: DateTime;
    begin
        CutoffDate := CreateDateTime(CalcDate('<-7D>', Today()), 0T);
        DataflowRefreshHistory.SetRange(Status, DataflowRefreshHistory.Status::Failed);
        DataflowRefreshHistory.SetFilter("Start Time", '>=%1', CutoffDate);
        exit(DataflowRefreshHistory.Count());
    end;

    local procedure GetLastErrorInfo(): Text
    var
        DatasetRefreshHistory: Record "PBI Dataset Refresh History";
        DataflowRefreshHistory: Record "PBI Dataflow Refresh History";
        LastDatasetError: DateTime;
        LastDataflowError: DateTime;
        ErrorInfo: Text;
        DatasetFormatLbl: Label 'Dataset: %1, Workspace: %2, Time: %3', Comment = '%1 = Dataset Name, %2 = Workspace Name, %3 = Error Time';
        DataflowFormatLbl: Label 'Dataflow: %1, Workspace: %2, Time: %3', Comment = '%1 = Dataflow Name, %2 = Workspace Name, %3 = Error Time';
        NoErrorsLbl: Label 'No recent errors found';
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

        // Return info about the most recent error
        if LastDatasetError > LastDataflowError then
            ErrorInfo := StrSubstNo(DatasetFormatLbl,
                DatasetRefreshHistory."Dataset Name",
                DatasetRefreshHistory."Workspace Name",
                Format(DatasetRefreshHistory."Start Time"))
        else
            if LastDataflowError <> 0DT then
                ErrorInfo := StrSubstNo(DataflowFormatLbl,
                    DataflowRefreshHistory."Dataflow Name",
                    DataflowRefreshHistory."Workspace Name",
                    Format(DataflowRefreshHistory."Start Time"))
            else
                ErrorInfo := NoErrorsLbl;

        exit(ErrorInfo);
    end;

    local procedure ShowRecentDatasetErrors()
    var
        DatasetRefreshHistory: Record "PBI Dataset Refresh History";
        DatasetRefreshHistoryPage: Page "PBI Dataset Refresh History";
        CutoffDate: DateTime;
    begin
        CutoffDate := CreateDateTime(CalcDate('<-7D>', Today()), 0T);
        DatasetRefreshHistory.SetRange(Status, DatasetRefreshHistory.Status::Failed);
        DatasetRefreshHistory.SetFilter("Start Time", '>=%1', CutoffDate);
        DatasetRefreshHistory.SetCurrentKey("Start Time");
        DatasetRefreshHistory.SetAscending("Start Time", false);
        DatasetRefreshHistoryPage.SetTableView(DatasetRefreshHistory);
        DatasetRefreshHistoryPage.Run();
    end;

    local procedure ShowRecentDataflowErrors()
    var
        DataflowRefreshHistory: Record "PBI Dataflow Refresh History";
        DataflowRefreshHistoryPage: Page "PBI Dataflow Refresh History";
        CutoffDate: DateTime;
    begin
        CutoffDate := CreateDateTime(CalcDate('<-7D>', Today()), 0T);
        DataflowRefreshHistory.SetRange(Status, DataflowRefreshHistory.Status::Failed);
        DataflowRefreshHistory.SetFilter("Start Time", '>=%1', CutoffDate);
        DataflowRefreshHistory.SetCurrentKey("Start Time");
        DataflowRefreshHistory.SetAscending("Start Time", false);
        DataflowRefreshHistoryPage.SetTableView(DataflowRefreshHistory);
        DataflowRefreshHistoryPage.Run();
    end;
}