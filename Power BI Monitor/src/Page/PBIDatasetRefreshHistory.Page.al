page 90135 "PBI Dataset Refresh History"
{
    Caption = 'PBI Dataset Refresh History';
    PageType = List;
    SourceTable = "PBI Dataset Refresh History";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }

                field("Dataset Name"; Rec."Dataset Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the dataset.';
                }

                field("Workspace Name"; Rec."Workspace Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the workspace.';
                }

                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the refresh started.';
                }

                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the refresh ended.';
                }

                field("Duration (Minutes)"; Rec."Duration (Minutes)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the refresh in minutes.';
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the refresh.';
                }

                field("Refresh Type"; Rec."Refresh Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of refresh.';
                }

                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any error message from the refresh.';
                    Visible = false;
                }

                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when this record was created.';
                }
            }
        }

        area(factboxes)
        {
            // Future: Add factbox for error details
        }
    }

    actions
    {
        area(processing)
        {
            group(Filters)
            {
                Caption = 'Filter Options';
                ToolTip = 'Actions for filtering the refresh history view';

                action(FilterByDataset)
                {
                    Caption = 'Filter by This Dataset';
                    ApplicationArea = All;
                    Image = Filter;
                    ToolTip = 'Filter to show only refresh history for the selected dataset.';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Dataset ID", Rec."Dataset ID");
                        CurrPage.Update(false);
                        Message('Filtered to show refresh history for dataset: %1', Rec."Dataset Name");
                    end;
                }

                action(FilterByWorkspace)
                {
                    Caption = 'Filter by This Workspace';
                    ApplicationArea = All;
                    Image = Filter;
                    ToolTip = 'Filter to show only refresh history for the selected workspace.';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Workspace ID", Rec."Workspace ID");
                        CurrPage.Update(false);
                        Message('Filtered to show refresh history for workspace: %1', Rec."Workspace Name");
                    end;
                }

                action(FilterByStatus)
                {
                    Caption = 'Filter by Status';
                    ApplicationArea = All;
                    Image = Filter;
                    ToolTip = 'Filter to show only refreshes with the selected status.';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Status", Rec."Status");
                        CurrPage.Update(false);
                        Message('Filtered to show only %1 refreshes.', Format(Rec."Status"));
                    end;
                }

                action(ShowFailedOnly)
                {
                    Caption = 'Show Failed Refreshes Only';
                    ApplicationArea = All;
                    Image = ErrorLog;
                    ToolTip = 'Filter to show only failed refresh operations for troubleshooting.';

                    trigger OnAction()
                    var
                        RefreshStatus: Enum "Power BI Refresh Status";
                    begin
                        Rec.SetRange("Status", RefreshStatus::Failed);
                        CurrPage.Update(false);
                        Message('Filtered to show only failed refreshes.');
                    end;
                }

                action(ClearFilters)
                {
                    Caption = 'Clear All Filters';
                    ApplicationArea = All;
                    Image = ClearFilter;
                    ToolTip = 'Clear all filters to show complete refresh history.';

                    trigger OnAction()
                    begin
                        Rec.Reset();
                        CurrPage.Update(false);
                        Message('All filters cleared. Showing complete refresh history.');
                    end;
                }
            }

            group(Details)
            {
                Caption = 'View Details';
                ToolTip = 'Actions for viewing detailed information about refresh operations';

                action(ViewErrorDetails)
                {
                    Caption = 'View Error Details';
                    ApplicationArea = All;
                    Image = ErrorLog;
                    ToolTip = 'View detailed error information for this failed refresh operation.';
                    Enabled = Rec."Status" = Rec."Status"::Failed;

                    trigger OnAction()
                    var
                        ErrorText: Text;
                    begin
                        ErrorText := Rec.GetServiceExceptionText();
                        if ErrorText <> '' then
                            Message('Detailed Error Information:\\\\%1', ErrorText)
                        else
                            if Rec."Error Message" <> '' then
                                Message('Error Message:\\\\%1', Rec."Error Message")
                            else
                                Message('No detailed error information available for this refresh operation.');
                    end;
                }

                action(ViewRefreshDetails)
                {
                    Caption = 'View Refresh Summary';
                    ApplicationArea = All;
                    Image = View;
                    ToolTip = 'View summary information for this refresh operation.';

                    trigger OnAction()
                    var
                        SummaryText: Text;
                    begin
                        SummaryText := 'Refresh Summary for Dataset: %1\\' +
                                       'Workspace: %2\\' +
                                       'Start Time: %3\\' +
                                       'End Time: %4\\' +
                                       'Duration: %5 minutes\\' +
                                       'Status: %6\\' +
                                       'Refresh Type: %7';

                        Message(SummaryText,
                            Rec."Dataset Name",
                            Rec."Workspace Name",
                            Format(Rec."Start Time"),
                            Format(Rec."End Time"),
                            Format(Rec."Duration (Minutes)"),
                            Format(Rec."Status"),
                            Rec."Refresh Type");
                    end;
                }
            }
        }

        area(navigation)
        {
            action(OpenDataset)
            {
                Caption = 'Open Dataset';
                ApplicationArea = All;
                Image = Database;
                ToolTip = 'Navigate to the dataset page for this refresh operation.';

                trigger OnAction()
                var
                    PowerBIDataset: Record "Power BI Dataset";
                    PowerBIDatasetsPage: Page "Power BI Datasets";
                begin
                    if PowerBIDataset.Get(Rec."Dataset ID", Rec."Workspace ID") then begin
                        PowerBIDatasetsPage.SetRecord(PowerBIDataset);
                        PowerBIDatasetsPage.Run();
                    end else
                        Message('Dataset not found. It may have been deleted or moved.');
                end;
            }
        }
    }
}