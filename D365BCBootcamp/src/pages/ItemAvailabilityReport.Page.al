// Demo: Embed a Power BI report as a full standalone page in Business Central.
// Based on: https://github.com/microsoft/BCTech/tree/master/samples/PowerBi/EmbedYourPBIApp
//           https://github.com/microsoft/BCTech/tree/master/samples/PowerBi/PBI23samples
//
// The page is "locked" to the report configured in the var section below.
// Users cannot switch to a different report from the UI.
// Replace every placeholder value (marked with TODO) before deploying to production.

page 80209 "PBI Item Availability Report"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Item Availability Report (Power BI)';
    AboutTitle = 'Item Availability - Power BI';
    AboutText = 'Displays a Power BI report embedded directly in Business Central. Replace the placeholder values in the AL source with your actual report IDs before deploying.';
    // PageType = UserControlHost makes the embedded part fill the entire page (BC 25+).
    PageType = Card;

    layout
    {
        area(Content)
        {
            part(EmbeddedReport; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'Item Availability';
                // The Context string links this part to the configuration in OnOpenPage.
                // Must be unique across ALL Power BI pages and must match vContext in the var section (max 30 chars).
                SubPageView = where(Context = const('80209-PBIItemAvail'));
            }
        }
    }

    trigger OnOpenPage()
    var
        PowerBIDisplayedElement: Record "Power BI Displayed Element";
        PowerBIContextSettings: Record "Power BI Context Settings";
        PowerBIEmbedSetupWizard: Page "Power BI Embed Setup Wizard";
    begin
        // Step 1: Ensure the user has completed the Power BI first-time setup wizard.
        PowerBIContextSettings.SetRange(UserSID, UserSecurityId());
        if PowerBIContextSettings.IsEmpty() then begin
            PowerBIEmbedSetupWizard.SetContext(vContext);
            if PowerBIEmbedSetupWizard.RunModal() <> Action::OK then;
            if PowerBIContextSettings.IsEmpty() then
                Error(PowerBiNotSetupErr);
        end;

        // Step 2: Add the report to the context (only once per user).
        //         The Get-check prevents creating a duplicate record on each page open.
        if not PowerBIDisplayedElement.Get(
            UserSecurityId(), vContext,
            PowerBIDisplayedElement.MakeReportKey(vReportId),
            PowerBIDisplayedElement.ElementType::Report)
        then begin
            PowerBIDisplayedElement.Init();
            PowerBIDisplayedElement.ElementType := PowerBIDisplayedElement.ElementType::Report;
            PowerBIDisplayedElement.ElementId := PowerBIDisplayedElement.MakeReportKey(vReportId);
            // The Embed URL is retrieved from Power BI REST API (GET /v1.0/myorg/reports)
            // or from Power BI Online: File > Embed report > Website or portal → copy the src="..." URL.
            // See: https://learn.microsoft.com/en-us/rest/api/power-bi/reports/get-reports
            PowerBIDisplayedElement.ElementEmbedUrl := vReportEmbedUrl;
            PowerBIDisplayedElement.Context := vContext;
            PowerBIDisplayedElement.UserSID := UserSecurityId();
            PowerBIDisplayedElement.ReportPage := vReportPage;
            PowerBIDisplayedElement.ShowPanesInExpandedMode := true;
            PowerBIDisplayedElement.ShowPanesInNormalMode := true;
            PowerBIDisplayedElement.Insert();
        end;

        // Step 3: Lock the context so users cannot switch to a different report from the UI.
        PowerBIContextSettings.CreateOrReadForCurrentUser(vContext);
        if not PowerBIContextSettings.LockToSelectedElement then begin
            PowerBIContextSettings.LockToSelectedElement := true;
            PowerBIContextSettings.Modify();
        end;

        // Step 4: Expand the embedded part to fill the entire page (requires BC 24.2 or later).
        CurrPage.EmbeddedReport.Page.SetFullPageMode(true);
    end;

    var
        PowerBiNotSetupErr: Label 'Power BI is not set up. You need to complete the Power BI setup before you can view this report.';
        // TODO: Replace with your actual Power BI Report GUID.
        // Open the report in Power BI Online and copy the GUID from the URL:
        //   https://app.powerbi.com/groups/<workspace-id>/reports/<REPORT-ID>/...
        // Or use the Power BI REST API: https://learn.microsoft.com/en-us/rest/api/power-bi/reports/get-reports
        vReportId: Label '<YOUR-POWER-BI-REPORT-ID>', Locked = true;
        // TODO: Replace with the Embed URL for the report above.
        // Retrieve it via Power BI REST API: GET https://api.powerbi.com/v1.0/myorg/reports
        // OR from Power BI Online: File > Embed report > Website or portal (copy the src="..." value).
        vReportEmbedUrl: Label 'https://app.powerbi.com/reportEmbed?reportId=<YOUR-POWER-BI-REPORT-ID>&config=<YOUR-CONFIG>', Locked = true;
        // TODO: Replace with the page (tab) name to display by default. Leave empty ('') for the first/default page.
        vReportPage: Label '<YOUR-REPORT-PAGE-NAME>', Locked = true;
        vContext: Label '80209-PBIItemAvail', MaxLength = 30, Locked = true,
            Comment = 'IMPORTANT: Must be unique across all Power BI pages. Must match the Context value used in SubPageView above.';
}
