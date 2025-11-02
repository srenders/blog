query 70100 CustomerLedgers
{
    QueryType = Normal;

    elements
    {
        dataitem(Customer; Customer)
        {

            column(No; "No.") { }
            column(Name; Name) { }
            dataitem(CustomerLedgers; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = Customer."No.";
                SqlJoinType = InnerJoin;

                column(PostingYear; "Posting Date") { Method = Year; }
                column(PostingMonth; "Posting Date") { Method = Month; }
                column(DocumentType; "Document Type") { }
                column(AmountLCY; "Amount (LCY)") { Method = Sum; }
            }
        }
    }
}