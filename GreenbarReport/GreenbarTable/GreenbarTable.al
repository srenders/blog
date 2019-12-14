report 50142 "Greenbar Table"
{
    Caption = 'Greenbar Table';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    AdditionalSearchTerms = 'Greenbar Table';
    DefaultLayout = RDLC;
    RDLCLayout = '.\GreenbarTable\GreenbarTable.rdl';
    ProcessingOnly = false;

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            column(No_Item; Item."No.")
            {
                IncludeCaption = true;
            }
            column(Description_Item; Item.Description)
            {
                IncludeCaption = true;
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                column(LocationCode_ItemLedgerEntry; "Item Ledger Entry"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
                {
                    IncludeCaption = true;
                }
            }
        }
    }

    labels
    {
        ReportName = 'My Greenbar Table Report';
    }
}

