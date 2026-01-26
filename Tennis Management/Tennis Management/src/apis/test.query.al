query 60123 Test
{
    QueryType = Normal;

    elements
    {
        dataitem(Customer; Customer)
        {


            column(City; City) { }
            dataitem(Cust__Ledger_Entry; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = Customer."No.";

                column(AmountLCY; "Amount (LCY)") { Method = Sum; }
                column(PostingDate; "Posting Date") { Method = Month; }
            }
        }
    }



    trigger OnBeforeOpen()
    begin

    end;
}