page 90140 "Power BI Dashboards"
{
    ApplicationArea = All;
    Caption = 'Power BI Dashboards';
    PageType = List;
    SourceTable = "Power BI Dashboard";
    UsageCategory = Lists;
    CardPageId = 90141;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Dashboard Name"; Rec."Dashboard Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the Power BI dashboard.';
                }

                field("Workspace Name"; Rec."Workspace Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the workspace that contains this dashboard.';
                }

                field("Display Name"; Rec."Display Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the display name of the dashboard.';
                }

                field("Tile Count"; Rec."Tile Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of tiles in this dashboard.';
                }

                field("Is ReadOnly"; Rec."Is ReadOnly")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the dashboard is read-only.';
                }

                field("Is Featured"; Rec."Is Featured")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the dashboard is featured.';
                }

                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the dashboard was created.';
                }

                field("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the dashboard was last modified.';
                }

                field("Last Sync Date"; Rec."Last Sync Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the dashboard was last synchronized.';
                }
            }
        }

        area(FactBoxes)
        {
            // Factbox can be added later when needed
        }
    }

    actions
    {
        area(Processing)
        {
            group("Refresh Operations")
            {
                Caption = 'Refresh Operations';
                Image = Refresh;

                action(SyncAllDashboards)
                {
                    ApplicationArea = All;
                    Caption = 'Sync All Dashboards';
                    Image = RefreshLines;
                    ToolTip = 'Synchronize all dashboards from Power BI.';

                    trigger OnAction()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if not Confirm('Do you want to synchronize all dashboards from Power BI?') then
                            exit;

                        if PowerBIAPIOrchestrator.SynchronizeAllDashboards() then
                            Message('Successfully synchronized dashboards.')
                        else
                            Message('Dashboard synchronization failed.');
                        CurrPage.Update(false);
                    end;
                }

                action(SyncDashboardsForWorkspace)
                {
                    ApplicationArea = All;
                    Caption = 'Sync Dashboards for This Workspace';
                    Image = Refresh;
                    ToolTip = 'Synchronize dashboards for the selected workspace.';

                    trigger OnAction()
                    var
                        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                    begin
                        if IsNullGuid(Rec."Workspace ID") then begin
                            Message('Please select a dashboard first.');
                            exit;
                        end;

                        if not Confirm('Do you want to synchronize dashboards for workspace %1?', false, Rec."Workspace Name") then
                            exit;

                        if PowerBIAPIOrchestrator.SynchronizeDashboards(Rec."Workspace ID") then
                            Message('Successfully synchronized dashboards for workspace %1.', Rec."Workspace Name")
                        else
                            Message('Dashboard synchronization failed for workspace %1.', Rec."Workspace Name");
                        CurrPage.Update(false);
                    end;
                }

                action(RefreshTileCount)
                {
                    ApplicationArea = All;
                    Caption = 'Refresh Tile Count';
                    Image = RefreshRegister;
                    ToolTip = 'Refresh the tile count for the selected dashboard.';

                    trigger OnAction()
                    begin
                        if Rec.RefreshTileCount() then begin
                            Message('Tile count refreshed successfully.');
                            CurrPage.Update(false);
                        end else
                            Message('Failed to refresh tile count.');
                    end;
                }
            }

            group("Filter Options")
            {
                Caption = 'Filter Options';
                Image = FilterLines;

                action(ShowFeaturedOnly)
                {
                    ApplicationArea = All;
                    Caption = 'Show Featured Only';
                    Image = ShowSelected;
                    ToolTip = 'Show only featured dashboards.';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Is Featured", true);
                        CurrPage.Update(false);
                    end;
                }

                action(ShowReadOnlyOnly)
                {
                    ApplicationArea = All;
                    Caption = 'Show Read-Only Only';
                    Image = Lock;
                    ToolTip = 'Show only read-only dashboards.';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Is ReadOnly", true);
                        CurrPage.Update(false);
                    end;
                }

                action(ShowAllDashboards)
                {
                    ApplicationArea = All;
                    Caption = 'Show All Dashboards';
                    Image = ClearFilter;
                    ToolTip = 'Clear all filters and show all dashboards.';

                    trigger OnAction()
                    begin
                        Rec.Reset();
                        CurrPage.Update(false);
                    end;
                }
            }

            group("View Details")
            {
                Caption = 'View Details';
                Image = View;

                action(OpenInPowerBI)
                {
                    ApplicationArea = All;
                    Caption = 'Open in Power BI';
                    Image = Web;
                    ToolTip = 'Open this dashboard in Power BI portal.';

                    trigger OnAction()
                    begin
                        Rec.OpenInPowerBI();
                    end;
                }

                action(ShowWorkspace)
                {
                    ApplicationArea = All;
                    Caption = 'Show Workspace';
                    Image = Worksheet;
                    ToolTip = 'Show the workspace that contains this dashboard.';

                    trigger OnAction()
                    var
                        PowerBIWorkspace: Record "Power BI Workspace";
                        PowerBIWorkspacePage: Page "Power BI Workspaces";
                    begin
                        if PowerBIWorkspace.Get(Rec."Workspace ID") then begin
                            PowerBIWorkspacePage.SetRecord(PowerBIWorkspace);
                            PowerBIWorkspacePage.Run();
                        end;
                    end;
                }

                action(ViewEmbedDetails)
                {
                    ApplicationArea = All;
                    Caption = 'View Embed Details';
                    Image = CodesList;
                    ToolTip = 'View embedding details for this dashboard.';

                    trigger OnAction()
                    var
                        EmbedUrl: Text;
                    begin
                        EmbedUrl := Rec.GetEmbedInfo();
                        if EmbedUrl <> '' then
                            Message('Embed URL:\n%1', EmbedUrl)
                        else
                            Message('No embed URL available for this dashboard.');
                    end;
                }
            }
        }

        area(Navigation)
        {
            // Navigation actions can be added when needed
        }
    }
}