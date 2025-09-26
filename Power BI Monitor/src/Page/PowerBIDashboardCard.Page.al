page 90141 "Power BI Dashboard Card"
{
    ApplicationArea = All;
    Caption = 'Power BI Dashboard Card';
    PageType = Card;
    SourceTable = "Power BI Dashboard";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Dashboard Name"; Rec."Dashboard Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the Power BI dashboard.';
                    Importance = Promoted;
                }

                field("Display Name"; Rec."Display Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the display name of the dashboard.';
                }

                field("Workspace Name"; Rec."Workspace Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the workspace that contains this dashboard.';
                    Importance = Promoted;
                }

                field("Dashboard ID"; Rec."Dashboard ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier of the dashboard.';
                    Importance = Additional;
                }

                field("Workspace ID"; Rec."Workspace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier of the workspace.';
                    Importance = Additional;
                }
            }

            group(Properties)
            {
                Caption = 'Properties';

                field("Tile Count"; Rec."Tile Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of tiles in this dashboard.';
                    Importance = Promoted;
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

            group(URLs)
            {
                Caption = 'URLs';

                field("Web URL"; Rec."Web URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the web URL for accessing this dashboard in Power BI.';
                    ExtendedDatatype = URL;
                }

                field("Embed URL"; Rec."Embed URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the embed URL for embedding this dashboard.';
                    ExtendedDatatype = URL;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenInPowerBI)
            {
                ApplicationArea = All;
                Caption = 'Open in Power BI';
                Image = Web;
                ToolTip = 'Open this dashboard in Power BI portal.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.OpenInPowerBI();
                end;
            }

            action(RefreshTileCount)
            {
                ApplicationArea = All;
                Caption = 'Refresh Tile Count';
                Image = RefreshRegister;
                ToolTip = 'Refresh the tile count for this dashboard.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec.RefreshTileCount() then begin
                        Message('Tile count refreshed successfully.');
                        CurrPage.Update(false);
                    end else
                        Message('Failed to refresh tile count.');
                end;
            }

            action(CopyEmbedURL)
            {
                ApplicationArea = All;
                Caption = 'Copy Embed URL';
                Image = Copy;
                ToolTip = 'Copy the embed URL to clipboard.';

                trigger OnAction()
                var
                    EmbedUrl: Text;
                begin
                    EmbedUrl := Rec.GetEmbedInfo();
                    if EmbedUrl <> '' then
                        Message('Embed URL copied:\n%1', EmbedUrl)
                    else
                        Message('No embed URL available for this dashboard.');
                end;
            }
        }

        area(Navigation)
        {
            action(RelatedWorkspace)
            {
                ApplicationArea = All;
                Caption = 'Related Workspace';
                Image = Relationship;
                ToolTip = 'View the workspace that contains this dashboard.';

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
        }
    }
}