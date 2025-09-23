codeunit 90140 "Power BI Assisted Setup"
{
    // Handles assisted setup registration for Power BI Monitor

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure OnRegisterAssistedSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
    begin
        GuidedExperience.InsertAssistedSetup(
            'Power BI Monitor Setup',
            'Power BI Monitor Setup',
            'Set up Power BI Monitor to synchronize and manage Power BI content from Business Central.',
            5,
            ObjectType::Page,
            Page::"Power BI Setup Wizard",
            AssistedSetupGroup::Extensions,
            '',
            VideoCategory::Uncategorized,
            ''
        );
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnAfterRunAssistedSetup', '', false, false)]
    local procedure OnAfterRunAssistedSetup(ExtensionId: Guid; ObjectType: ObjectType; ObjectID: Integer)
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        if (ObjectType = ObjectType::Page) and (ObjectID = Page::"Power BI Setup Wizard") then
            GuidedExperience.CompleteAssistedSetup(ObjectType::Page, Page::"Power BI Setup Wizard");
    end;

    /// <summary>
    /// Starts the Power BI setup wizard
    /// </summary>
    procedure StartSetupWizard()
    var
        PowerBISetupWizard: Page "Power BI Setup Wizard";
    begin
        PowerBISetupWizard.RunModal();
    end;

    /// <summary>
    /// Checks if Power BI Monitor is configured
    /// </summary>
    /// <returns>True if basic configuration is complete</returns>
    procedure IsSetupComplete(): Boolean
    var
        PowerBISetup: Record "Power BI Setup";
    begin
        if not PowerBISetup.Get('') then
            exit(false);

        exit((PowerBISetup."Client ID" <> '') and
             (PowerBISetup."Client Secret" <> '') and
             (PowerBISetup."Tenant ID" <> ''));
    end;
}