report 70102 join
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'DEMO - Join';
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            column(No_Customer; "No.") { }
            column(Name_Customer; Name) { }
            column(City_Customer; City) { }
            column(CountryRegionCode_Customer; "Country/Region Code") { }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = sorting("Entry No.");

                column(PostingDate_CustLedgerEntry; "Posting Date") { }
                column(DocumentType_CustLedgerEntry; "Document Type") { }
                column(AmountLCY_CustLedgerEntry; "Amount (LCY)") { }
            }
        }
    }

    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './src/reports/03 join/join.rdl';
            Caption = '03 join RDLC';
            Summary = 'Shows 03 join';
        }
        layout(WORDLayout)
        {
            Type = Word;
            LayoutFile = './src/reports/03 join/join.docx';
            Caption = '03 join WORD';
            Summary = 'Shows 03 join';
        }
    }
}