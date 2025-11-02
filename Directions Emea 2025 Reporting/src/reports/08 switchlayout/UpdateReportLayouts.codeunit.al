codeunit 70100 UpdateReportLayouts
{

    procedure SetReportSelection(UsageOption: Enum "Report Selection Usage"; ReportId: Integer)
    var
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, UsageOption);
        if ReportSelections.FindFirst() then begin
            ReportSelections.Validate("Report ID", ReportId);
            ReportSelections.Modify(true);
        end;
    end;

    procedure UpdateTenantLayoutSelection(ReportId: Integer; LayoutName: Text[250])
    var
        ReportLayoutList: Record "Report Layout List";
        TenantReportLayoutSelection: Record "Tenant Report Layout Selection";
        AppInfo: ModuleInfo;
        EmptyGuid: Guid;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);
        ReportLayoutList.Reset();
        ReportLayoutList.SetRange("Application ID", AppInfo.Id);
        ReportLayoutList.SetRange("Report ID", ReportId);
        ReportLayoutList.SetRange(Name, LayoutName);
        if ReportLayoutList.FindFirst() then begin
            TenantReportLayoutSelection."App ID" := ReportLayoutList."Application ID";
            TenantReportLayoutSelection."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TenantReportLayoutSelection."Company Name"));
            TenantReportLayoutSelection."Layout Name" := ReportLayoutList.Name;
            TenantReportLayoutSelection."Report ID" := ReportLayoutList."Report ID";
            TenantReportLayoutSelection."User ID" := EmptyGuid;
            if not TenantReportLayoutSelection.Insert(true) then
                TenantReportLayoutSelection.Modify(true);
        end;
    end;

}