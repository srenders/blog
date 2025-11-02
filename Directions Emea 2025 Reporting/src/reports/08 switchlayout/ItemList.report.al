report 70106 ItemList
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ItemListWordOrange;
    Caption = 'DEMO - 08 switchlayout';

    dataset
    {
        dataitem(Item; Item)
        {
            column(No_Item; "No.") { }
            column(Description_Item; Description) { }
            column(Type_Item; "Type") { }
            column(Inventory_Item; Inventory) { }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(UseOrangeLayout; UseOrangeLayout)
                    {
                        ApplicationArea = All;
                        Caption = 'Use Orange Layout';
                        ToolTip = 'Select to use the orange layout for the report.';
                        trigger OnValidate()
                        begin
                            if UseOrangeLayout then
                                UseBlueLayout := false;
                            SetReportLayout();
                        end;
                    }
                    field(UseBlueLayout; UseBlueLayout)
                    {
                        ApplicationArea = All;
                        Caption = 'Use Blue Layout';
                        ToolTip = 'Select to use the blue layout for the report.';
                        trigger OnValidate()
                        begin
                            if UseBlueLayout then
                                UseOrangeLayout := false;
                            SetReportLayout();
                        end;
                    }
                }
            }
        }
    }

    rendering
    {
        layout(ItemListWordOrange)
        {
            Type = Word;
            LayoutFile = './src/reports/08 switchlayout/ItemListOrange.docx';
        }
        layout(ItemListWordBlue)
        {
            Type = Word;
            LayoutFile = './src/reports/08 switchlayout/ItemListBlue.docx';
        }
    }

    var
        UseOrangeLayout, UseBlueLayout : Boolean;

    trigger OnInitReport()
    begin
        this.UseOrangeLayout := true; // Default to orange layout
        this.UseBlueLayout := false;
        SetReportLayout()
    end;

    trigger OnPreReport()
    begin
        SetReportLayout();
    end;

    local procedure SetReportLayout()
    var
        UpdateReportLayouts: Codeunit UpdateReportLayouts;
    begin
        if this.UseOrangeLayout then
            UpdateReportLayouts.UpdateTenantLayoutSelection(report::ItemList, 'ItemListWordOrange')
        else
            if this.UseBlueLayout then
                UpdateReportLayouts.UpdateTenantLayoutSelection(report::ItemList, 'ItemListWordBlue');
        commit();
    end;
}