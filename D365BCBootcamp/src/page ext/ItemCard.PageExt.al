// Demo: Embed a Power BI report visual as a FactBox on the Item Card page.
// Based on: https://github.com/microsoft/BCTech/tree/master/samples/PowerBi/PBI23samples
//
// This is the simplest embedding pattern:
// a single method call in OnOpenPage is all that is needed to link a
// specific Power BI report visual to the FactBox for all users.
// Replace the placeholder values (marked with TODO) before deploying to production.

pageextension 80210 "PBI Item Card Factbox" extends "Item Card"
{
    layout
    {
        addfirst(factboxes)
        {
            part(PowerBIPart; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'Power BI Report';
                // The Context string identifies which report visual is shown for this FactBox.
                // Must be unique across all Power BI parts and must match the context used in OnOpenPage below.
                SubPageView = where(Context = const('PBIItemCardFactbox'));
            }
        }
    }

    trigger OnOpenPage()
    var
        PowerBIServiceMgt: Codeunit "Power BI Service Mgt.";
    begin
        // AddReportVisualForContext links a specific Power BI report visual to this FactBox context.
        // This is an idempotent call – it is safe to run on every page open.
        //
        // How to find the three IDs:
        //   1. Open your Power BI report in Power BI Online (app.powerbi.com)
        //   2. Hover over the visual you want to embed, click the three-dots menu (...)
        //   3. Choose Share > Link to this Visual, then click Copy
        //   4. The generated URL contains all three values:
        //        https://app.powerbi.com/groups/me/reports/<REPORT-ID>/<PAGE-ID>?...&visual=<VISUAL-ID>
        //
        // TODO: Replace the three placeholder strings below with your actual IDs.
        PowerBIServiceMgt.AddReportVisualForContext(
            '<YOUR-POWER-BI-REPORT-ID>',   // Report GUID  (e.g. '061ce0f5-3918-44ee-b820-a8d0d384fb2e')
            '<YOUR-REPORT-PAGE-ID>',        // Page ID      (e.g. 'ReportSection1')
            '<YOUR-VISUAL-ID>',             // Visual ID    (e.g. 'ab1fcfce118c0d14d565')
            'PBIItemCardFactbox');           // Context – must match the SubPageView above
    end;
}
