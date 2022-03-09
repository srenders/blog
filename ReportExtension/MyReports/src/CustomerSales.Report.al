report 50100 CustomerSales
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Extensible = true;
    RDLCLayout = 'src/CustomerSales.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_Customer; "No.")
            {
                IncludeCaption = true;
            }
            column(Name_Customer; Name)
            {
                IncludeCaption = true;
            }
            dataitem(customerLedger; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");

                column(CustomerNo_customerLedger; "Customer No.")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_customerLedger; "Posting Date")
                {
                    IncludeCaption = true;
                }
                column(AmountLCY_customerLedger; "Amount (LCY)")
                {
                    IncludeCaption = true;
                }
            }
        }
    }
}