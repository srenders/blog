reportextension 50100 CustomerSalesRepExt extends CustomerSales
{
    RDLCLayout = 'src/CustomerSalesExt.rdl';
    dataset
    {
        // Add changes to dataitems and columns here
        add(Customer)
        {
            column(City_Customer; City)
            {
                IncludeCaption = true;
            }
        }
        add(customerLedger)
        {
            column(Currency_Code;"Currency Code")
            {
                IncludeCaption = true;
            }
        }
    }
}