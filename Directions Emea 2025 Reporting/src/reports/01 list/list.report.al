report 70103 list
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'DEMO - List';
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(Customer; Customer)
        {

            column(No_Customer; "No.") { }
            column(Name_Customer; Name) { }
            column(City_Customer; City) { }
            column(CountryRegionCode_Customer; "Country/Region Code") { }
            column(SalesLCY_Customer; "Sales (LCY)") { }
        }
    }


    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './src/reports/01 list/list.rdl';
            Caption = '01 List RDLC';
            Summary = 'Shows 01 List';
        }
        layout(WORDLayout)
        {
            Type = Word;
            LayoutFile = './src/reports/01 list/list.docx';
            Caption = '01 List WORD';
            Summary = 'Shows 02 List';
        }
        layout(EXCELLayout)
        {
            Type = Excel;
            LayoutFile = './src/reports/01 list/list.xlsx';
            Caption = '01 List EXCEL';
            Summary = 'Shows 02 List';
        }
    }

}