report 70108 ItemAvailability
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'DEMO - ItemAvailability';
    DefaultRenderingLayout = EXCELLayout;
    ExcelLayoutMultipleDataSheets = true;

    dataset
    {
        dataitem(Item; Item)
        {

            column(No_Item; "No.") { }
            column(Description_Item; Description) { }
            column(Inventory_Item; Inventory) { }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = sorting("Item No.");
                DataItemLink = "Item No." = field("No.");
                column(ItemNo_ItemLedgerEntry; "Item No.") { }
                column(LocationCode_ItemLedgerEntry; "Location Code") { }

                column(PostingDate_ItemLedgerEntry; "Posting Date") { }
                column(Quantity_ItemLedgerEntry; Quantity) { }
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemTableView = sorting("Document No.") where(Type = const(Item));
                DataItemLink = "No." = field("No.");
                column(ItemNo_SalesLine; "No.") { }
                column(LocationCode_SalesLine; "Location Code") { }

                column(ShipmentDate_SalesLine; "Shipment Date") { }
                column(Quantity_SalesLine; Quantity) { }
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = sorting("Document No.") where(Type = const(Item));
                DataItemLink = "No." = field("No.");
                column(ItemNo_PurchaseLine; "No.") { }
                column(LocationCode_PurchaseLine; "Location Code") { }

                column(ExpectedReceiptDate_PurchaseLine; "Expected Receipt Date") { }
                column(Quantity_PurchaseLine; Quantity) { }
            }
        }
    }


    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './src/reports/09 Item Availability/ItemAvailabilityCustomers.rdl';
            Caption = 'Item Availability RDLC';
            Summary = 'Shows Item Availability';
        }
        layout(EXCELLayout)
        {
            Type = Excel;
            LayoutFile = './src/reports/09 Item Availability/ItemAvailabilityCustomers.xlsx';
            Caption = 'Item Availability EXCEL';
            Summary = 'Shows Item Availability';
        }
        layout(WORDLayout)
        {
            Type = Word;
            LayoutFile = './src/reports/09 Item Availability/ItemAvailabilityCustomers.docx';
            Caption = 'Item Availability WORD';
            Summary = 'Shows Item Availability';
        }
    }
}