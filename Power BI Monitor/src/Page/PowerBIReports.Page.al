page 90116 "Power BI Reports"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Power BI Report";
    Caption = 'Power BI Reports';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(ReportsList)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the Power BI report.';
                }
                field("Workspace Name"; Rec."Workspace Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the workspace that contains this report.';
                }
                field("Dataset Name"; Rec."Dataset Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dataset used by this report.';
                }
                field("Report Type"; Rec."Report Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of Power BI report.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the report was created.';
                }
                field("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the report was last modified.';
                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who last modified the report.';
                }
                field("Is Owned By Me"; Rec."Is Owned By Me")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the current user owns this report.';
                }
                field("Last Sync"; Rec."Last Sync")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the report information was last synchronized.';
                }
            }
        }
        area(FactBoxes)
        {
            part(RefreshHistoryFactBox; "PBI Report Dataset RefreshList")
            {
                ApplicationArea = All;
                Caption = 'Dataset Refresh History';
                SubPageLink = "Dataset ID" = field("Dataset ID");
            }

            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Synchronization)
            {
                Caption = 'Synchronization';

                action(SyncReports)
                {
                    ApplicationArea = All;
                    Caption = 'Synchronize Reports';
                    Image = Refresh;
                    ToolTip = 'Synchronize Power BI reports from all workspaces.';

                    trigger OnAction()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if PowerBIAPIOrchestrator.SynchronizeReports() then
                            Message('Reports synchronized successfully.')
                        else
                            Message('Report synchronization completed with some errors.');
                        CurrPage.Update(false);
                    end;
                }

                action(SyncSelectedWorkspace)
                {
                    ApplicationArea = All;
                    Caption = 'Sync Selected Workspace';
                    Image = Refresh;
                    ToolTip = 'Synchronize reports from the selected workspace only.';

                    trigger OnAction()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if IsNullGuid(Rec."Workspace ID") then
                            Error('Please select a report first.');

                        if PowerBIAPIOrchestrator.SynchronizeReportsForWorkspace(Rec."Workspace ID") then
                            Message('Reports synchronized successfully for selected workspace.')
                        else
                            Message('Workspace report synchronization completed with some errors.');
                        CurrPage.Update(false);
                    end;
                }
            }

            group(ReportNavigation)
            {
                Caption = 'Navigation';

                action(OpenInPowerBI)
                {
                    ApplicationArea = All;
                    Caption = 'Open in Power BI';
                    Image = Web;
                    ToolTip = 'Open the report in Power BI service.';

                    trigger OnAction()
                    begin
                        if Rec."Web URL" = '' then
                            Error('No web URL available for this report.');

                        Hyperlink(Rec."Web URL");
                    end;
                }

                action(ViewDataset)
                {
                    ApplicationArea = All;
                    Caption = 'View Dataset';
                    Image = Database;
                    ToolTip = 'View the dataset used by this report.';

                    trigger OnAction()
                    var
                        PowerBIDataset: Record "Power BI Dataset";
                    begin
                        if IsNullGuid(Rec."Dataset ID") then
                            Error('No dataset associated with this report.');

                        PowerBIDataset.SetRange("Dataset ID", Rec."Dataset ID");
                        PowerBIDataset.SetRange("Workspace ID", Rec."Workspace ID");
                        if PowerBIDataset.FindFirst() then
                            Page.Run(Page::"Power BI Datasets", PowerBIDataset)
                        else
                            Error('Dataset not found. Please synchronize datasets first.');
                    end;
                }

                action(ViewWorkspace)
                {
                    ApplicationArea = All;
                    Caption = 'View Workspace';
                    Image = Warehouse;
                    ToolTip = 'View the workspace that contains this report.';

                    trigger OnAction()
                    var
                        PowerBIWorkspace: Record "Power BI Workspace";
                    begin
                        PowerBIWorkspace.SetRange("Workspace ID", Rec."Workspace ID");
                        if PowerBIWorkspace.FindFirst() then
                            Page.Run(Page::"Power BI Workspaces", PowerBIWorkspace)
                        else
                            Error('Workspace not found.');
                    end;
                }
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(SyncReports_Promoted; SyncReports)
                {
                }
                actionref(OpenInPowerBI_Promoted; OpenInPowerBI)
                {
                }
            }
        }
    }

    views
    {
        view(ByWorkspace)
        {
            Caption = 'By Workspace';
            OrderBy = ascending(Name);
        }
        view(RecentlyModified)
        {
            Caption = 'Recently Modified';
            OrderBy = descending("Modified Date");
        }
        view(MyReports)
        {
            Caption = 'My Reports';
            Filters = where("Is Owned By Me" = const(true));
            OrderBy = descending("Modified Date");
        }
    }
}