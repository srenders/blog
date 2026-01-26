codeunit 60115 "Tennis Assisted Setup"
{
    Subtype = Normal;

    trigger OnRun()
    begin
        RunAssistedSetup();
    end;

    var
        TennisSetupAssistedTxt: Label 'Set up Tennis Management';
        TennisSetupDescTxt: Label 'Set up number series for Tennis Management.';
        TennisSetupHelpTxt: Label 'https://example.com/help/tennis-management';
        AlreadySetUpQst: Label 'Tennis Management is already set up. Do you want to change the setup?';

    procedure RegisterAssistedSetup()
    var
        AssistedSetup: Codeunit "Guided Experience";
        GuidedExperienceType: Enum "Guided Experience Type";
        VideoCategory: Enum "Video Category";
        AssistedSetupGroup: Enum "Assisted Setup Group";
    begin
        if AssistedSetup.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::"Tennis Setup Wizard") then
            exit;

        AssistedSetup.InsertAssistedSetup(
            TennisSetupAssistedTxt,
            TennisSetupDescTxt,
            TennisSetupDescTxt,
            1,  // Completion order/priority
            ObjectType::Page,
            Page::"Tennis Setup Wizard",
            AssistedSetupGroup::GettingStarted,
            '',
            VideoCategory::Uncategorized,
            TennisSetupHelpTxt);
    end;

    procedure IsAssistedSetupComplete(): Boolean
    var
        TennisSetup: Record "Tennis Setup";
        AssistedSetup: Codeunit "Guided Experience";
        GuidedExperienceType: Enum "Guided Experience Type";
    begin
        if not TennisSetup.Get() then
            exit(false);

        if TennisSetup."Player Nos." = '' then
            exit(false);

        if TennisSetup."Match Nos." = '' then
            exit(false);

        if not AssistedSetup.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::"Tennis Setup Wizard") then
            RegisterAssistedSetup();

        exit(AssistedSetup.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::"Tennis Setup Wizard"));
    end;

    procedure RunAssistedSetup()
    var
        TennisSetup: Record "Tennis Setup";
        AssistedSetup: Codeunit "Guided Experience";
        GuidedExperienceType: Enum "Guided Experience Type";
    begin
        if not TennisSetup.Get() then
            TennisSetup.Insert();

        if IsAssistedSetupComplete() then
            if not Confirm(AlreadySetUpQst) then
                exit;

        if not AssistedSetup.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::"Tennis Setup Wizard") then
            RegisterAssistedSetup();

        Page.RunModal(Page::"Tennis Setup Wizard", TennisSetup);

        // Mark as complete only after wizard is closed successfully
        if (TennisSetup."Player Nos." <> '') and (TennisSetup."Match Nos." <> '') then
            AssistedSetup.CompleteAssistedSetup(ObjectType::Page, Page::"Tennis Setup Wizard");
    end;
}
