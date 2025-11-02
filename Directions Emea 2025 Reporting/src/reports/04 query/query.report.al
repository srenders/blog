// Example of how to use a query as the data source for a report dataset.
report 70105 Query
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'DEMO - Query';
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(No; CustomerLedgers.No) { }
            column(Name; CustomerLedgers.Name) { }
            column(DocumentType; CustomerLedgers.DocumentType) { }
            column(PostingMonth; CustomerLedgers.PostingMonth) { }
            column(PostingYear; CustomerLedgers.PostingYear) { }
            column(AmountLCY; CustomerLedgers.AmountLCY) { }

            trigger OnPreDataItem()
            begin
                CustomerLedgers.Open();
            end;

            trigger OnAfterGetRecord()
            begin
                if not CustomerLedgers.Read() then
                    CurrReport.Break();
            end;
        }
    }


    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './src/reports/04 query/query.rdl';
            Caption = '04 query RDLC';
            Summary = 'Shows 04 query';
        }
    }

    var
        CustomerLedgers: Query CustomerLedgers;
}