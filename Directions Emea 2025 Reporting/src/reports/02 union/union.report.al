report 70104 union
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'DEMO - Union';
    DefaultRenderingLayout = WORDLayout;

    dataset
    {
        dataitem(Customer; Customer)
        {

            column(No_Customer; "No.") { }
            column(Name_Customer; Name) { }
            column(EMail_Customer; "E-Mail") { }
            column(HomePage_Customer; "Home Page") { }
        }
        dataitem(Vendor; Vendor)
        {
            column(No_Vendor; "No.") { }
            column(Name_Vendor; Name) { }
        }
    }


    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './src/reports/02 union/union.rdl';
            Caption = '02 union RDLC';
            Summary = 'Shows 02 union';
        }
        layout(WORDLayout)
        {
            Type = Word;
            LayoutFile = './src/reports/02 union/union.docx';
            Caption = '02 union WORD';
            Summary = 'Shows 02 union';
        }
        layout(WORDLayoutSections)
        {
            Type = Word;
            LayoutFile = './src/reports/02 union/unionsections.docx';
            Caption = '02 union sections WORD';
            Summary = 'Shows 02 union sections';
        }
        layout(WORDLayoutLinks)
        {
            Type = Word;
            LayoutFile = './src/reports/02 union/unionLinks.docx';
            Caption = '02 union Links WORD';
            Summary = 'Shows 02 union Links';
        }
    }

}