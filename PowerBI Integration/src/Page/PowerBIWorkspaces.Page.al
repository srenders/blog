page 90112 "Power BI Workspaces"
{
    Caption = 'Power BI Workspaces';
    PageType = List;
    SourceTable = "Power BI Workspace";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Workspace ID"; Rec."Workspace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier of the Power BI workspace.';
                }

                field("Workspace Name"; Rec."Workspace Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the Power BI workspace.';
                }

                field("Workspace Type"; Rec."Workspace Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the Power BI workspace.';
                }

                field("Is Read Only"; Rec."Is Read Only")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the workspace is read-only.';
                }

                field("Sync Enabled"; Rec."Sync Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether synchronization is enabled for this workspace.';
                }

                field("Last Synchronized"; Rec."Last Synchronized")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the workspace information was last synchronized.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SynchronizeWorkspaces)
            {
                Caption = 'Sync Workspace List from Power BI';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Synchronize all workspaces from Power BI.';

                trigger OnAction()
                var
                    PowerBIAPI: Codeunit "Power BI API Management";
                begin
                    if PowerBIAPI.SynchronizeWorkspaces() then begin
                        CurrPage.Update(false);
                        Message('Workspaces synchronized successfully.');
                    end else
                        Message('Failed to synchronize workspaces. Please check your authentication configuration.');
                end;
            }

            action(SynchronizeDatasets)
            {
                Caption = 'Sync Datasets for This Workspace';
                ApplicationArea = All;
                Image = UpdateDescription;
                ToolTip = 'Synchronize datasets for the selected workspace.';

                trigger OnAction()
                var
                    PowerBIAPI: Codeunit "Power BI API Management";
                begin
                    if PowerBIAPI.SynchronizeDatasets(Rec."Workspace ID") then begin
                        CurrPage.Update(false);
                        Message('Datasets synchronized successfully for workspace: %1', Rec."Workspace Name");
                    end else
                        Message('Failed to synchronize datasets for workspace: %1', Rec."Workspace Name");
                end;
            }

            action(ViewDatasets)
            {
                Caption = 'View Datasets';
                ApplicationArea = All;
                Image = DataEntry;
                ToolTip = 'View datasets in the selected workspace.';

                trigger OnAction()
                var
                    PowerBIDataset: Record "Power BI Dataset";
                    PowerBIDatasetsPage: Page "Power BI Datasets";
                begin
                    PowerBIDataset.SetRange("Workspace ID", Rec."Workspace ID");
                    PowerBIDatasetsPage.SetTableView(PowerBIDataset);
                    PowerBIDatasetsPage.Run();
                end;
            }
        }

        area(navigation)
        {
            action(PowerBIPortal)
            {
                Caption = 'Open in Power BI';
                ApplicationArea = All;
                Image = Web;
                ToolTip = 'Open this workspace in the Power BI portal.';

                trigger OnAction()
                var
                    WorkspaceUrl: Text;
                begin
                    WorkspaceUrl := 'https://app.powerbi.com/groups/' + Format(Rec."Workspace ID").Replace('{', '').Replace('}', '');
                    HyperLink(WorkspaceUrl);
                end;
            }
        }
    }
}