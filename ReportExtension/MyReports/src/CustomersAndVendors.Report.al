report 50101 CustomersAndVendors
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'src/CustomersAndVendors.rdl';



    dataset
    {
        dataitem(Customer; Customer)
        {
            column(dataitem_customer; 'dataitem_customer')
            { }
            column(No_Customer; "No.")
            { }
            column(Name_Customer; Name)
            { }
        }
        dataitem(Vendor; Vendor)
        {
            column(dataitem_vendor; 'dataitem_vendor')
            { }
            column(No_Vendor; "No.")
            { }
            column(Name_Vendor; Name)
            { }
        }
    }
}