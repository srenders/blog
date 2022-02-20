query 50400 Customers
{
    APIGroup = 'powerBI';
    APIPublisher = 'contoso';
    APIVersion = 'v2.0';
    EntityName = 'qrycustomer';
    EntitySetName = 'qrycustomers';
    QueryType = API;
    DataAccessIntent = ReadOnly;

    
    elements
    {
        dataitem(customer; Customer)
        {
            column(customerNo; "No.")
            {
            }
            column(customerName; Name)
            {
            }
            column(countryRegionCode; "Country/Region Code")
            {
            }
            column(city; City)
            {
            }
            column(salespersonCode; "Salesperson Code")
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
