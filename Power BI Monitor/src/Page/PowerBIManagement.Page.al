page 90118 "Power BI Management"
{
    Caption = 'Power BI Management';
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Setup)
            {
                Caption = 'Setup';

                field(SetupDescription; 'Configure Power BI Monitor settings and connection')
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }

            group(Management)
            {
                Caption = 'Management';

                field(ManagementDescription; 'Manage Power BI workspaces, datasets, and dataflows')
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    Style = Attention;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(SetupActions)
            {
                Caption = 'Setup';

                action(SetupWizard)
                {
                    Caption = 'Setup Wizard';
                    ApplicationArea = All;
                    Image = Setup;
                    ToolTip = 'Open the guided setup wizard to configure Power BI Monitor step by step.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PowerBISetupWizard: Page "Power BI Setup Wizard";
                    begin
                        PowerBISetupWizard.RunModal();
                    end;
                }

                action(SetupPage)
                {
                    Caption = 'Setup Page';
                    ApplicationArea = All;
                    Image = Setup;
                    ToolTip = 'Open the Power BI setup page for advanced configuration.';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PowerBISetup: Page "Power BI Setup";
                    begin
                        PowerBISetup.RunModal();
                    end;
                }
            }

            group(ManagementActions)
            {
                Caption = 'Management';

                action(Workspaces)
                {
                    Caption = 'Workspaces';
                    ApplicationArea = All;
                    Image = Worksheets;
                    ToolTip = 'View and manage Power BI workspaces.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PowerBIWorkspaces: Page "Power BI Workspaces";
                    begin
                        PowerBIWorkspaces.Run();
                    end;
                }

                action(Datasets)
                {
                    Caption = 'Datasets';
                    ApplicationArea = All;
                    Image = Database;
                    ToolTip = 'View and manage Power BI datasets.';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PowerBIDatasets: Page "Power BI Datasets";
                    begin
                        PowerBIDatasets.Run();
                    end;
                }

                action(Dataflows)
                {
                    Caption = 'Dataflows';
                    ApplicationArea = All;
                    Image = Flow;
                    ToolTip = 'View and manage Power BI dataflows.';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PowerBIDataflows: Page "Power BI Dataflows";
                    begin
                        PowerBIDataflows.Run();
                    end;
                }
            }
        }
    }
}