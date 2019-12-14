report 50100 PurchaseExample1
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'PurchaseExample1';
    RDLCLayout = 'PurchaseExample1.rdl';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            PrintOnlyIfDetail = true;                           // This is to skip header that has no lines
            RequestFilterFields = "No.", "Document Type";       //  These are the default fields in the request page

            column(DocumentNo; "No.")
            {
            }
            column(BuyfromVendorNo; "Buy-from Vendor No.")
            {
            }
            column(BuyfromVendorName; "Buy-from Vendor Name")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");   // This is the link from Line to Header
                DataItemTableView = sorting("Line No.");        // This is to remove the data item from Request Page

                column(No; "No.")
                {
                }
                column(Type; Type)
                {
                }
                column(Amount; Amount)
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
