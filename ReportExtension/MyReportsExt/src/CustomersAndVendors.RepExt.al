reportextension 50101 CustomersAndVendorsRepExt extends CustomersAndVendors
{
    RDLCLayout = 'src/CustomersAndVendorsRepExt.rdl';

    dataset
    {

        // Add changes to dataitems and columns here
        add(Customer)
        {

            column(City_Customer; City)
            { }
        }
        add(Vendor)
        {
            column(City_Vendor; City)
            { }
        }
        addlast(Vendor)
        {
            dataitem(Contact; Contact)
            {
                column(dataitem_contact; 'dataitem_contact')
                { }
                column(No_Contact; "No.")
                { }
                column(Name_Contact; Name)
                { }
                column(City_Contact; City)
                { }
            }
        }
    }
}