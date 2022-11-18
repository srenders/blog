report 50102 Shipments
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Shipments';
    DefaultRenderingLayout = Shipments1;

    dataset
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableView = where(Type = filter('Item'));

            column(DocumentNo; "Document No.")
            { }
            column(DocumentType; "Document Type")
            { }
            column(ItemNo; "No.")
            { }
            column(ShipmentDate; "Shipment Date")
            { }
            column(ShipmentYear; System.Date2DMY("Shipment Date", 3))
            { }
            column(ShipmentMonth; System.Date2DMY("Shipment Date", 2))
            { }
            column(QtytoShip; "Qty. to Ship")
            { }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Sell-to Customer No.");
                DataItemTableView = sorting("No.");

                column(CustomerNo; "No.")
                { }
                column(CustomerName; Name)
                { }
            }
        }
    }

    rendering
    {
        layout(Shipments1)
        {
            Type = Excel;
            LayoutFile = './src/reports/Shipments/Shipments1.xlsx';
            Summary = 'Shipments layout, pivot and chart.';
        }
    }
}