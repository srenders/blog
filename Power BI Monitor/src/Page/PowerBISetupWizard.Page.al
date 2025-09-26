page 90117 "Power BI Setup Wizard"
{
    Caption = 'Power BI Monitor Setup Wizard';
    PageType = NavigatePage;
    SourceTable = "Power BI Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(BannerGroup)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible;

                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(Step1)
            {
                Caption = '';
                Visible = Step1Visible;

                group("Welcome")
                {
                    Caption = 'Welcome to Power BI Monitor Setup';
                    InstructionalText = 'This wizard will guide you through setting up Power BI Monitor for Business Central. You will need to register an application in Azure AD and configure API permissions.';

                    field(WelcomeText; WelcomeText)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Overview of the setup process.';
                    }
                }
            }

            group(Step2)
            {
                Caption = '';
                Visible = Step2Visible;

                group("Azure AD Registration")
                {
                    Caption = 'Step 1: Azure AD Application Registration';
                    InstructionalText = 'First, you need to register an application in Azure Active Directory to enable API access to Power BI.';

                    field(AzureInstructions; AzureInstructions)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Instructions for registering the Azure AD application.';
                    }

                    field(OpenAzurePortalAction; 'Open Azure Portal')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        Style = StandardAccent;
                        StyleExpr = true;

                        trigger OnDrillDown()
                        begin
                            Hyperlink('https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade');
                        end;
                    }
                }
            }

            group(Step3)
            {
                Caption = '';
                Visible = Step3Visible;

                group("API Permissions")
                {
                    Caption = 'Step 2: Configure API Permissions';
                    InstructionalText = 'Configure the required Power BI API permissions for your Azure AD application.';

                    field(PermissionsInstructions; PermissionsInstructions)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Instructions for configuring API permissions.';
                    }
                }
            }

            group(Step4)
            {
                Caption = '';
                Visible = Step4Visible;

                group("SecretCreation")
                {
                    Caption = 'Step 3: Create Client Secret';
                    InstructionalText = 'Create a client secret for authentication. Make sure to copy it immediately as you won''t be able to see it again.';

                    field(SecretInstructions; SecretInstructions)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Instructions for creating a client secret.';
                    }
                }
            }

            group(Step5)
            {
                Caption = '';
                Visible = Step5Visible;

                group("Configuration")
                {
                    Caption = 'Step 4: Enter Configuration Details';
                    InstructionalText = 'Enter the details from your Azure AD application registration.';

                    field("Client ID"; Rec."Client ID")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Application (client) ID from the Azure AD app registration overview page.';
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            ValidateStep5();
                        end;
                    }

                    field("WizardClientSecret"; Rec."Client Secret")
                    {
                        ApplicationArea = All;
                        Caption = 'Client Secret';
                        ToolTip = 'Enter the client secret value you created in Azure AD.';
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            ValidateStep5();
                        end;
                    }

                    field("Tenant ID"; Rec."Tenant ID")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Directory (tenant) ID from the Azure AD app registration overview page.';
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            ValidateStep5();
                        end;
                    }

                    field("Authority URL"; Rec."Authority URL")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The Azure AD authority URL for authentication. Usually this is the default value.';
                    }

                    field("Power BI API URL"; Rec."Power BI API URL")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The Power BI REST API base URL. Usually this is the default value.';
                    }
                }
            }

            group(Step6)
            {
                Caption = '';
                Visible = Step6Visible;

                group("Test Connection")
                {
                    Caption = 'Step 5: Test Connection';
                    InstructionalText = 'Test the connection to ensure everything is configured correctly.';

                    field(TestInstructions; TestInstructions)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Instructions for testing the connection.';
                    }

                    field(ConnectionStatus; ConnectionStatusText)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Connection Status';
                        ToolTip = 'Shows the current connection test status.';
                        Style = Attention;
                        StyleExpr = ConnectionStatusStyle;
                    }
                }
            }

            group(Step7)
            {
                Caption = '';
                Visible = Step7Visible;

                group("Completion")
                {
                    Caption = 'Setup Complete!';
                    InstructionalText = 'Your Power BI Monitor is now configured and ready to use.';

                    field(CompletionText; CompletionText)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Setup completion information.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    GoToPreviousStep();
                end;
            }

            action(Next)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    GoToNextStep();
                end;
            }

            action(TestConnection)
            {
                ApplicationArea = All;
                Caption = 'Test Connection';
                Enabled = TestConnectionEnabled;
                Image = TestDatabase;
                InFooterBar = true;
                Visible = Step6Visible;

                trigger OnAction()
                begin
                    TestPowerBIConnection();
                end;
            }

            action(Finish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinishEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    FinishSetup();
                end;
            }
        }
    }

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesStandard: Record "Media Resources";
        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
        Step: Option Welcome,AzureRegistration,APIPermissions,ClientSecret,Configuration,TestConnection,Finish;
        TopBannerVisible: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        Step4Visible: Boolean;
        Step5Visible: Boolean;
        Step6Visible: Boolean;
        Step7Visible: Boolean;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        TestConnectionEnabled: Boolean;
        FinishEnabled: Boolean;
        ConnectionStatusText: Text;
        ConnectionStatusStyle: Boolean;
        WelcomeText: Text;
        AzureInstructions: Text;
        PermissionsInstructions: Text;
        SecretInstructions: Text;
        TestInstructions: Text;
        CompletionText: Text;

    trigger OnInit()
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get('') then begin
            Rec.Init();
            Rec.Insert();
        end;

        InitializeWizard();
        SetDefaultValues();
        ShowStep(Step::Welcome);
    end;

    local procedure InitializeWizard()
    begin
        Step := Step::Welcome;
        InitializeTexts();
        ConnectionStatusText := 'Not tested';
        ConnectionStatusStyle := false;
    end;

    local procedure InitializeTexts()
    begin
        WelcomeText := 'This setup wizard will help you configure Power BI Monitor for Business Central.\' +
                      '\' +
                      'You will need:\' +
                      '• Access to Azure Active Directory admin portal\' +
                      '• Permissions to register applications in Azure AD\' +
                      '• Permissions to grant admin consent for API permissions\' +
                      '\' +
                      'The setup process involves:\' +
                      '1. Registering an application in Azure AD\' +
                      '2. Configuring Power BI API permissions\' +
                      '3. Creating a client secret\' +
                      '4. Entering configuration details\' +
                      '5. Testing the connection';

        AzureInstructions := 'Follow these steps to register an application in Azure AD:\' +
                           '\' +
                           '1. Click "Open Azure Portal" below (or go to portal.azure.com)\' +
                           '2. Navigate to Azure Active Directory > App registrations\' +
                           '3. Click "New registration"\' +
                           '4. Enter a name like "Business Central Power BI Monitor"\' +
                           '5. Select "Accounts in this organizational directory only"\' +
                           '6. Leave Redirect URI empty\' +
                           '7. Click "Register"\' +
                           '\' +
                           'After registration, note down:\' +
                           '• Application (client) ID\' +
                           '• Directory (tenant) ID\' +
                           '\' +
                           'You will need these values in a later step.';

        PermissionsInstructions := 'Configure API permissions for your registered application:\' +
                                 '\' +
                                 '1. In your app registration, go to "API permissions"\' +
                                 '2. Click "Add a permission"\' +
                                 '3. Select "Power BI Service" from the list\' +
                                 '4. Choose "Application permissions"\' +
                                 '5. Add these permissions:\' +
                                 '   ✓ Dataset.Read.All\' +
                                 '   ✓ Dataset.ReadWrite.All\' +
                                 '   ✓ Dataflow.Read.All\' +
                                 '   ✓ Dataflow.ReadWrite.All\' +
                                 '   ✓ Group.Read.All\' +
                                 '   ✓ Workspace.Read.All\' +
                                 '6. Click "Add permissions"\' +
                                 '7. Click "Grant admin consent" and confirm\' +
                                 '\' +
                                 'Important: Admin consent is required for these permissions to work.';

        SecretInstructions := 'Create a client secret for authentication:\' +
                            '\' +
                            '1. In your app registration, go to "Certificates & secrets"\' +
                            '2. Click "New client secret"\' +
                            '3. Enter a description like "BC Integration Secret"\' +
                            '4. Choose an appropriate expiration period\' +
                            '5. Click "Add"\' +
                            '6. IMPORTANT: Copy the secret VALUE immediately\' +
                            '   (You won''t be able to see it again!)\' +
                            '\' +
                            'Security note:\' +
                            '• Store the secret securely\' +
                            '• Set a calendar reminder before expiration\' +
                            '• Plan to rotate secrets regularly';

        TestInstructions := 'Test the connection to validate your configuration:\' +
                          '\' +
                          '1. Click "Test Connection" below\' +
                          '2. The system will attempt to authenticate with Azure AD\' +
                          '3. If successful, it will try to access Power BI workspaces\' +
                          '\' +
                          'If the test fails, check:\' +
                          '• All configuration values are correct\' +
                          '• Admin consent was granted for API permissions\' +
                          '• Client secret is valid and not expired\' +
                          '• Network connectivity to Azure AD and Power BI';

        CompletionText := 'Congratulations! Your Power BI Monitor is now configured.\' +
                        '\' +
                        'You can now:\' +
                        '• Synchronize Power BI workspaces\' +
                        '• View and manage datasets\' +
                        '• View and manage dataflows\' +
                        '• Trigger refresh operations\' +
                        '• Monitor refresh status and performance\' +
                        '\' +
                        'Next steps:\' +
                        '1. Go to Power BI Workspaces page\' +
                        '2. Click "Refresh All Workspaces" to synchronize\' +
                        '3. Explore the datasets and dataflows\' +
                        '\' +
                        'For ongoing management, use the Power BI Setup page\' +
                        'to modify configuration settings.';
    end;

    local procedure SetDefaultValues()
    begin
        if Rec."Authority URL" = '' then
            Rec."Authority URL" := 'https://login.microsoftonline.com/';

        if Rec."Power BI API URL" = '' then
            Rec."Power BI API URL" := 'https://api.powerbi.com/v1.0/myorg/';
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") then
                TopBannerVisible := MediaResourcesStandard."Media Reference".HasValue();
    end;

    local procedure ShowStep(NewStep: Option)
    begin
        Step := NewStep;
        ResetControls();

        case Step of
            Step::Welcome:
                ShowWelcomeStep();
            Step::AzureRegistration:
                ShowAzureRegistrationStep();
            Step::APIPermissions:
                ShowAPIPermissionsStep();
            Step::ClientSecret:
                ShowClientSecretStep();
            Step::Configuration:
                ShowConfigurationStep();
            Step::TestConnection:
                ShowTestConnectionStep();
            Step::Finish:
                ShowFinishStep();
        end;

        CurrPage.Update();
    end;

    local procedure ResetControls()
    begin
        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;
        Step4Visible := false;
        Step5Visible := false;
        Step6Visible := false;
        Step7Visible := false;
        BackEnabled := false;
        NextEnabled := false;
        TestConnectionEnabled := false;
        FinishEnabled := false;
    end;

    local procedure ShowWelcomeStep()
    begin
        Step1Visible := true;
        NextEnabled := true;
    end;

    local procedure ShowAzureRegistrationStep()
    begin
        Step2Visible := true;
        BackEnabled := true;
        NextEnabled := true;
    end;

    local procedure ShowAPIPermissionsStep()
    begin
        Step3Visible := true;
        BackEnabled := true;
        NextEnabled := true;
    end;

    local procedure ShowClientSecretStep()
    begin
        Step4Visible := true;
        BackEnabled := true;
        NextEnabled := true;
    end;

    local procedure ShowConfigurationStep()
    begin
        Step5Visible := true;
        BackEnabled := true;
        ValidateStep5();
    end;

    local procedure ShowTestConnectionStep()
    begin
        Step6Visible := true;
        BackEnabled := true;
        TestConnectionEnabled := true;
        ValidateStep6();
    end;

    local procedure ShowFinishStep()
    begin
        Step7Visible := true;
        BackEnabled := true;
        FinishEnabled := true;
    end;

    local procedure ValidateStep5()
    begin
        NextEnabled := (Rec."Client ID" <> '') and (Rec."Client Secret" <> '') and (Rec."Tenant ID" <> '');
    end;

    local procedure ValidateStep6()
    begin
        NextEnabled := ConnectionStatusText = 'Connection successful';
    end;

    local procedure GoToPreviousStep()
    begin
        case Step of
            Step::AzureRegistration:
                ShowStep(Step::Welcome);
            Step::APIPermissions:
                ShowStep(Step::AzureRegistration);
            Step::ClientSecret:
                ShowStep(Step::APIPermissions);
            Step::Configuration:
                ShowStep(Step::ClientSecret);
            Step::TestConnection:
                ShowStep(Step::Configuration);
            Step::Finish:
                ShowStep(Step::TestConnection);
        end;
    end;

    local procedure GoToNextStep()
    begin
        case Step of
            Step::Welcome:
                ShowStep(Step::AzureRegistration);
            Step::AzureRegistration:
                ShowStep(Step::APIPermissions);
            Step::APIPermissions:
                ShowStep(Step::ClientSecret);
            Step::ClientSecret:
                begin
                    SaveConfiguration();
                    ShowStep(Step::Configuration);
                end;
            Step::Configuration:
                begin
                    SaveConfiguration();
                    ShowStep(Step::TestConnection);
                end;
            Step::TestConnection:
                ShowStep(Step::Finish);
        end;
    end;

    local procedure SaveConfiguration()
    begin
        if not Rec.Modify() then
            Rec.Insert();
    end;

    local procedure TestPowerBIConnection()
    begin
        SaveConfiguration();

        if PowerBIAPIOrchestrator.SynchronizeWorkspaces() then begin
            ConnectionStatusText := 'Connection successful';
            ConnectionStatusStyle := false;
            ValidateStep6();
        end else begin
            ConnectionStatusText := 'Connection failed - check configuration';
            ConnectionStatusStyle := true;
        end;

        CurrPage.Update();
    end;

    local procedure FinishSetup()
    begin
        SaveConfiguration();
        Message('Power BI Monitor setup completed successfully!\' +
                '\' +
                'You can now use the Power BI workspaces, datasets, and dataflows pages\' +
                'to manage your Power BI content from Business Central.');
        CurrPage.Close();
    end;
}