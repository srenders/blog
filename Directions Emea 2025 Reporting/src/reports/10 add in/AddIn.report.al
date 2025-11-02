report 70109 AddIn
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = Example1;
    Caption = 'DEMO - AddIn';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_Customer; "No.") { IncludeCaption = true; }
            column(Name_Customer; Name) { IncludeCaption = true; }
            column(City_Customer; City) { IncludeCaption = true; }
            column(BalanceLCY_Customer; "Balance (LCY)") { IncludeCaption = true; }
        }
        dataitem(Vendor; Vendor)
        {
            column(No_Vendor; "No.") { IncludeCaption = true; }
            column(Name_Vendor; Name) { IncludeCaption = true; }
            column(City_Vendor; City) { IncludeCaption = true; }
            column(BalanceLCY_Vendor; "Balance (LCY)") { IncludeCaption = true; }
        }
    }

    rendering
    {
        layout(Example1)
        {
            Type = Word;
            LayoutFile = './src/reports/10 add in/Example1.docx';
            Summary = 'Word Layout 2 tables, comments, hide if zero.';
        }
        layout(Example2)
        {
            Type = Word;
            LayoutFile = './src/reports/10 add in/Example2.docx';
            Summary = 'Word Layout 2 tables, comments, hide if zero.';
        }
    }
}