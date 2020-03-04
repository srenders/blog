query 70100 "Item Cross Sales"
{
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = Type = const(Item);
            filter(DocumentType; "Document Type") { }
            filter(DocumentNo; "Document No.") { }
            filter(LineNo; "Line No.") { }
            filter(Type; Type) { }
            filter(No; "No.") { }
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "No." = SalesLine."No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = Type = const(Item);
                filter(PostingDate; "Posting Date") { }
                dataitem(SalesInvoiceLine2; "Sales Invoice Line")
                {
                    DataItemLink = "Document No." = SalesInvoiceLine."Document No.";
                    SqlJoinType = InnerJoin;
                    DataItemTableFilter = Type = const(Item);
                    column(ItemNumber; "No.") { }
                    column(CountOfItem)
                    {
                        Method = Count;
                    }
                    dataitem(Item; Item)
                    {
                        DataItemLink = "No." = SalesInvoiceLine2."No.";
                        column(Description; Description) { }
                        column(UnitPrice; "Unit Price") { }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
