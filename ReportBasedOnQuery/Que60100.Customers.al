query 60100 TopXCustomers
{
    QueryType = Normal;
    OrderBy = descending(BalanceLCY);
    TopNumberOfRows = 3;
    elements
    {
        dataitem(Customer; Customer)
        {
            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(BalanceLCY; "Balance (LCY)")
            { }
        }
    }
}
