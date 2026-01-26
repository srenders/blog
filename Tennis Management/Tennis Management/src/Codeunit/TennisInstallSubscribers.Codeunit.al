codeunit 60116 "Tennis Install Subscribers"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        TennisAssistedSetup: Codeunit "Tennis Assisted Setup";
    begin
        TennisAssistedSetup.RegisterAssistedSetup();
    end;
}
