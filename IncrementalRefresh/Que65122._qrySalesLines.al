query 65122 _qrySalesLines
{
    QueryType = Normal;
    Caption = '_qrySalesLines';

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            column(DocumentNo; "Document No.")
            { }
            column(DocumentType; "Document Type")
            { }
            column(Type; Type)
            { }
            column(No; "No.")
            { }
            column(Description; Description)
            { }
            column(Quantity; Quantity)
            { }
            column(Amount; Amount)
            { }
            column(PostingDate; "Posting Date")
            { }
            column(ShipmentDate; "Shipment Date")
            { }
            column(Last_Date_Modified; "Last Date Modified")
            { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
