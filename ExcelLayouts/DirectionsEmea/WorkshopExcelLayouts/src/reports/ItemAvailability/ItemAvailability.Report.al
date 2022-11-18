report 50100 ItemAvailability
{
    ApplicationArea = All;
    Caption = 'ItemAvailability';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = ItemAvailability1;

    dataset
    {
        dataitem(Item; Item)
        {
            column(ItemNo; "No.")
            { }
            column(ItemDescription; Description)
            { }
            column(ItemName; Description + ' (' + Format("No.") + ')')
            { }
            dataitem(ItemLedger; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = sorting("Item No.");

                column(Year; System.Date2DMY("Posting Date", 3))
                { }
                column(Month; System.Date2DMY("Posting Date", 2))
                { }
                column(LocationCode; "Location Code")
                { }
                column(Quantity; Quantity)
                { }
                dataitem(Location; Location)
                {
                    DataItemTableView = sorting(Code);
                    DataItemLink = Code = field("Location Code");
                    column(LocationName; Name)
                    { }
                }
            }
        }
    }
    rendering
    {
        layout(ItemAvailability1)
        {
            Type = Excel;
            LayoutFile = './src/reports/ItemAvailability/ItemAvailability1.xlsx';
            Summary = 'ItemAvailability layout, chart.';
        }
    }
}
