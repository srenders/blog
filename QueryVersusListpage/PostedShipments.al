query 60101 PostedShipments
{
    QueryType = Normal;
    Caption = 'PostedShipments';

    elements
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            dataitem(SalesShipmentLine; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = SalesShipmentHeader."No.";
                DataItemTableFilter = Type = const(Item);
                column(ItemNo; "No.")
                {
                }
                column(TotalQuantity; Quantity)
                {
                    Method = Sum;
                }
            }
        }
    }
}
