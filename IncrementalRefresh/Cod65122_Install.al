codeunit 65122 InstallationCodeunit
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    var
        SalesLine: Record "Sales Line";
    begin
        clear(SalesLine);
        SalesLine.SetRange("Last Date Modified", 0DT);
        SalesLine.ModifyAll("Last Date Modified", CurrentDateTime);
    end;
}