pageextension 80200 "PBI Item List" extends "Item List"
{
    layout
    {
        // Add changes to page layout here
        addafter(InventoryField)
        {
            field(AvailabilityVar; AvailabilityVar)
            {
                ApplicationArea = All;
                Caption = 'Availability';
                ToolTip = 'Availability';
                Editable = false;
                StyleExpr = "FieldStyle";
            }
        }
    }
    actions
    {
        addlast(Functions)
        {
            action(GetAvailabilitySelected)
            {
                ApplicationArea = All;
                Caption = 'Calculate Availability Selected';
                ToolTip = 'Calculate Availability Selected';
                Image = Inventory;
                ShortcutKey = 'Shift+Ctrl+A';

                trigger OnAction()
                begin
                    CalculateAvailabilitySelected()
                end;
            }


            // Demo: Open a Power BI report or report visual in an expanded (full-screen) card view.
            // Based on: https://github.com/microsoft/BCTech/tree/master/samples/PowerBi/PBI23samples
            //
            // Both actions use a *temporary* "Power BI Displayed Element" record that is passed directly
            // to "Power BI Element Card" without persisting any user configuration.
            // Replace every placeholder value (marked with TODO) before deploying to production.

            // Open the full Item Availability report in an expanded card view.
            action(OpenPBIItemReportExpanded)
            {
                ApplicationArea = All;
                Caption = 'Open Power BI Report (Expanded)';
                ToolTip = 'Opens the Power BI Item Availability report in a full-screen card view.';
                Image = PowerBI;

                trigger OnAction()
                var
                    TempPowerBIDisplayedElement: Record "Power BI Displayed Element" temporary;
                    PowerBIContextSettings: Record "Power BI Context Settings";
                    PowerBIEmbedSetupWizard: Page "Power BI Embed Setup Wizard";
                    PowerBIElementCard: Page "Power BI Element Card";
                begin
                    // Check that the user has completed the Power BI first-time setup wizard.
                    PowerBIContextSettings.SetRange(UserSID, UserSecurityId());
                    if PowerBIContextSettings.IsEmpty() then begin
                        PowerBIEmbedSetupWizard.SetContext('PBIItemListExpanded');
                        if PowerBIEmbedSetupWizard.RunModal() in [Action::Cancel, Action::LookupCancel] then
                            Error(UserDidNotAcceptPowerBITermsErr);
                    end;

                    // Build a temporary element record pointing to your Power BI report.
                    TempPowerBIDisplayedElement.Init();
                    TempPowerBIDisplayedElement.ElementType := TempPowerBIDisplayedElement.ElementType::Report;
                    // TODO: Replace with your actual Report GUID.
                    // Open the report in Power BI Online and copy the GUID from the URL:
                    //   https://app.powerbi.com/groups/<workspace-id>/reports/<REPORT-ID>/...
                    TempPowerBIDisplayedElement.ElementId :=
                        TempPowerBIDisplayedElement.MakeReportKey('<YOUR-POWER-BI-REPORT-ID>');
                    // TODO: Replace with your report Embed URL.
                    // Retrieve it from Power BI REST API: GET https://api.powerbi.com/v1.0/myorg/reports
                    // OR from Power BI Online: File > Embed report > Website or portal (copy the src="..." URL).
                    TempPowerBIDisplayedElement.ElementEmbedUrl :=
                        'https://app.powerbi.com/reportEmbed?reportId=<YOUR-POWER-BI-REPORT-ID>&config=<YOUR-CONFIG>';
                    // TODO: Replace with the page (tab) name to open by default. Leave empty for the default page.
                    TempPowerBIDisplayedElement.ReportPage := '<YOUR-REPORT-PAGE-NAME>';
                    TempPowerBIDisplayedElement.ShowPanesInExpandedMode := true;
                    TempPowerBIDisplayedElement.Insert();

                    // Open the report in the Power BI Element Card (full-screen viewer).
                    PowerBIElementCard.SetDisplayedElement(TempPowerBIDisplayedElement);
                    PowerBIElementCard.Run();
                end;
            }

            // Open a specific report visual in an expanded card view.
            // Useful for highlighting a single chart or KPI from a larger report.
            action(OpenPBIItemReportVisualExpanded)
            {
                ApplicationArea = All;
                Caption = 'Open Power BI Visual (Expanded)';
                ToolTip = 'Opens a specific Power BI report visual in a full-screen card view.';
                Image = BarChart;

                trigger OnAction()
                var
                    TempPowerBIDisplayedElement: Record "Power BI Displayed Element" temporary;
                    PowerBIContextSettings: Record "Power BI Context Settings";
                    PowerBIEmbedSetupWizard: Page "Power BI Embed Setup Wizard";
                    PowerBIElementCard: Page "Power BI Element Card";
                begin
                    PowerBIContextSettings.SetRange(UserSID, UserSecurityId());
                    if PowerBIContextSettings.IsEmpty() then begin
                        PowerBIEmbedSetupWizard.SetContext('PBIItemListExpanded');
                        if PowerBIEmbedSetupWizard.RunModal() in [Action::Cancel, Action::LookupCancel] then
                            Error(UserDidNotAcceptPowerBITermsErr);
                    end;

                    TempPowerBIDisplayedElement.Init();
                    TempPowerBIDisplayedElement.ElementType := TempPowerBIDisplayedElement.ElementType::"Report Visual";
                    // TODO: Replace the three parameters below with your actual IDs.
                    // To find the Visual ID:
                    //   1. Open the report in Power BI Online
                    //   2. Hover over the visual  three-dots menu (...)  Share  Link to this Visual
                    //   3. Copy the URL. It contains all three values:
                    //        https://app.powerbi.com/groups/me/reports/<REPORT-ID>/<PAGE-ID>?...&visual=<VISUAL-ID>
                    TempPowerBIDisplayedElement.ElementId :=
                        TempPowerBIDisplayedElement.MakeReportVisualKey(
                            '<YOUR-POWER-BI-REPORT-ID>',  // Report GUID  (e.g. '061ce0f5-3918-44ee-b820-a8d0d384fb2e')
                            '<YOUR-REPORT-PAGE-ID>',       // Page ID      (e.g. 'ReportSection1')
                            '<YOUR-VISUAL-ID>');            // Visual ID    (e.g. 'ab1fcfce118c0d14d565')
                    // TODO: Embed URL  same report embed URL as used in OpenPBIItemReportExpanded above.
                    TempPowerBIDisplayedElement.ElementEmbedUrl :=
                        'https://app.powerbi.com/reportEmbed?reportId=<YOUR-POWER-BI-REPORT-ID>&config=<YOUR-CONFIG>';
                    TempPowerBIDisplayedElement.ShowPanesInExpandedMode := true;
                    TempPowerBIDisplayedElement.Insert();

                    PowerBIElementCard.SetDisplayedElement(TempPowerBIDisplayedElement);
                    PowerBIElementCard.Run();
                end;
            }
        }
    }

    var
        AvailabilityVar: Integer;
        FieldStyle: Text;
        UserDidNotAcceptPowerBITermsErr: Label 'We cannot perform this action because you haven''t set up the Power BI integration.';

    trigger OnAfterGetRecord()
    begin
        //
        rec.CalcFields(rec."Qty. on Purch. Order", rec."Qty. on Sales Order", rec.Inventory);

        AvailabilityVar := rec.Inventory + rec."Qty. on Purch. Order" - rec."Qty. on Sales Order";

        if AvailabilityVar = rec.Inventory then FieldStyle := 'Standard';
        if AvailabilityVar < rec.Inventory then FieldStyle := 'Attention';
        if AvailabilityVar > rec.Inventory then FieldStyle := 'Favorable';
    end;

    local procedure CalculateAvailabilitySelected()
    var
        Item: Record Item;
        AvailabilityTotal: Decimal;
    begin
        Clear(Item);
        clear(AvailabilityTotal);

        CurrPage.SetSelectionFilter(Item);
        if Item.Count = 0 then
            Error('No items selected!')
        else
            repeat
                Item.CalcFields(Item."Qty. on Purch. Order", Item."Qty. on Sales Order", Item.Inventory);
                AvailabilityTotal += Item.Inventory + Item."Qty. on Purch. Order" - Item."Qty. on Sales Order";
            until item.Next() = 0;
        Message('The total availability of the selected items is %1', AvailabilityTotal);
    end;
}