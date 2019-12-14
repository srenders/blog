report 50102 PurchaseExample2
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'PurchaseExample2';
    RDLCLayout = 'PurchaseExample2.rdl';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            PrintOnlyIfDetail = true;                                   // This is to skip header that has no lines
            DataItemTableView = sorting("No.");                         // This is to remove the data item from Request Page

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
                DataItemLink = "Document No." = field("No.");           // This is the link from Line to Header
                DataItemTableView = sorting("Line No.");                // This is to remove the data item from Request Page

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
            trigger OnPreDataItem()                                     // This is the OnPreDataItem trigger of the Purchase Header
            begin
                SetRange(PurchaseHeader."No.", DocumentNumberFilter);   //I use the value of the var DocumentNumberFilter to filter the Purchase Header 
            end;
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
                    field(DocumentNumberFilter; DocumentNumberFilter)
                    {
                        TableRelation = "Purchase Header"."No.";        // To provide a dropdown to select the No
                        ApplicationArea = All;
                        Caption = 'Please filter on a Purchase Document: ';
                    }
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
    var
        DocumentNumberFilter: code[20];
}
