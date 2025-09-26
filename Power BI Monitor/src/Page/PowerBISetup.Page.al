page 90114 "Power BI Setup"
{
    Caption = 'Power BI Setup';
    PageType = Card;
    SourceTable = "Power BI Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(Authentication)
            {
                Caption = 'Azure AD Authentication';

                field("Client ID"; Rec."Client ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure AD Application (Client) ID for Power BI API access.';
                }

                field("Client Secret"; Rec."Client Secret")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure AD Application Client Secret for Power BI API access.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure AD Tenant ID for authentication.';
                }

                field("Authority URL"; Rec."Authority URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure AD authority URL for authentication.';
                }
            }

            group(PowerBI)
            {
                Caption = 'Power BI Configuration';

                field("Power BI API URL"; Rec."Power BI API URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Power BI REST API base URL.';
                }
            }

            group(Synchronization)
            {
                Caption = 'Synchronization Settings';

                field("Auto Sync Enabled"; Rec."Auto Sync Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether automatic synchronization is enabled.';
                }

                field("Sync Frequency (Hours)"; Rec."Sync Frequency (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how often to automatically sync data from Power BI (in hours).';
                }

                field("Last Auto Sync"; Rec."Last Auto Sync")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the last automatic sync was performed.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TestConnection)
            {
                Caption = 'Test Connection';
                ApplicationArea = All;
                Image = TestDatabase;
                ToolTip = 'Test the connection to Power BI with current settings.';

                trigger OnAction()
                var
                    PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
                begin
                    if PowerBIAPIOrchestrator.SynchronizeWorkspaces() then
                        Message('Connection test successful!')
                    else
                        Message('Connection test failed. Please check your configuration and error logs for details.');
                end;
            }

            action(SetupInstructions)
            {
                Caption = 'Setup Instructions';
                ApplicationArea = All;
                Image = Info;
                ToolTip = 'View setup instructions for configuring Power BI Monitor.';

                trigger OnAction()
                begin
                    ShowSetupInstructions();
                end;
            }

            action(SetupWizard)
            {
                Caption = 'Setup Wizard';
                ApplicationArea = All;
                Image = Setup;
                ToolTip = 'Open the guided setup wizard to configure Power BI Monitor step by step.';

                trigger OnAction()
                var
                    PowerBISetupWizard: Page "Power BI Setup Wizard";
                begin
                    PowerBISetupWizard.RunModal();
                end;
            }

            action(ManageAutoSync)
            {
                Caption = 'Manage Auto Sync';
                ApplicationArea = All;
                Image = Job;
                ToolTip = 'Enable or disable automatic synchronization and manage the job queue entry.';

                trigger OnAction()
                var
                    PowerBIAutoSync: Codeunit "Power BI Auto Sync";
                    ConfirmMsg: Text;
                begin
                    if Rec."Auto Sync Enabled" then
                        if PowerBIAutoSync.IsJobQueueEntryActive() then
                            Message('Auto sync is enabled and the job queue entry is active.')
                        else begin
                            ConfirmMsg := 'Auto sync is enabled but the job queue entry is not active. Do you want to create it?';
                            if Confirm(ConfirmMsg, false) then
                                if PowerBIAutoSync.CreateJobQueueEntry() then
                                    Message('Job queue entry created successfully.')
                                else
                                    Message('Failed to create job queue entry.');
                        end
                    else
                        if PowerBIAutoSync.IsJobQueueEntryActive() then begin
                            ConfirmMsg := 'Auto sync is disabled but the job queue entry is still active. Do you want to remove it?';
                            if Confirm(ConfirmMsg, false) then begin
                                PowerBIAutoSync.DeleteJobQueueEntry();
                                Message('Job queue entry removed.');
                            end;
                        end else
                            Message('Auto sync is disabled and no job queue entry exists.');
                end;
            }

            action(RunSyncNow)
            {
                Caption = 'Sync Now';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Run synchronization immediately regardless of schedule.';

                trigger OnAction()
                var
                    PowerBIAutoSync: Codeunit "Power BI Auto Sync";
                begin
                    if Confirm('Do you want to run synchronization now?', false) then begin
                        PowerBIAutoSync.RunAutoSync();
                        CurrPage.Update(false);
                        Message('Synchronization completed. Check the Last Auto Sync field for details.');
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('') then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec.Insert();
        end;
    end;

    local procedure ShowSetupInstructions()
    begin
        Message('Power BI Monitor Setup Instructions:\' +
                '\' +
                '1. Register an application in Azure AD:\' +
                '   - Go to Azure Portal > Azure Active Directory > App registrations\' +
                '   - Click "New registration"\' +
                '   - Enter a name for your application\' +
                '   - Select "Accounts in this organizational directory only"\' +
                '   - Click "Register"\' +
                '\' +
                '2. Configure API permissions:\' +
                '   - In your app registration, go to "API permissions"\' +
                '   - Click "Add a permission"\' +
                '   - Select "Power BI Service"\' +
                '   - Add the following permissions:\' +
                '     * Dataset.Read.All (for dataset operations)\' +
                '     * Dataset.ReadWrite.All (for dataset refresh)\' +
                '     * Dataflow.Read.All (for dataflow operations)\' +
                '     * Dataflow.ReadWrite.All (for dataflow refresh)\' +
                '     * Group.Read.All (for workspace access)\' +
                '     * Workspace.Read.All (for workspace operations)\' +
                '   - Grant admin consent\' +
                '\' +
                '3. Create a client secret:\' +
                '   - Go to "Certificates & secrets"\' +
                '   - Click "New client secret"\' +
                '   - Copy the secret value (you won''t see it again!)\' +
                '\' +
                '4. Configure this page:\' +
                '   - Client ID: Application (client) ID from overview page\' +
                '   - Client Secret: The secret value you copied\' +
                '   - Tenant ID: Directory (tenant) ID from overview page\' +
                '\' +
                '5. Test the connection using the "Test Connection" action.');
    end;
}