page 70100 RunReport
{
    Caption = 'DEMO - RunReport';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    //SourceTable = TableName;

    layout
    {
        area(Content) { }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(RunItemList)
            {
                ApplicationArea = All;
                Caption = 'RunItemList';
                ToolTip = 'RunItemList';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    UpdateReportLayouts: Codeunit UpdateReportLayouts;
                begin
                    UpdateReportLayouts.UpdateTenantLayoutSelection(report::ItemList,'ItemListWordOrange');
                    Commit();
                    report.Run(report::ItemList);
                end;
            }
            action(RunItemListUpdated)
            {
                ApplicationArea = All;
                Caption = 'RunItemListUpdated';
                ToolTip = 'RunItemListUpdated';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    UpdateReportLayouts: Codeunit UpdateReportLayouts;
                begin
                    UpdateReportLayouts.UpdateTenantLayoutSelection(report::ItemList,'ItemListWordBlue');
                    Commit();
                    report.Run(report::ItemList);
                end;
            }
        }
    }
}