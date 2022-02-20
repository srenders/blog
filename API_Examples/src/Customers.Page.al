page 50400 Customers
{
    APIGroup = 'powerBI';
    APIPublisher = 'contoso';
    APIVersion = 'v2.0';
    Caption = 'customers';
    DelayedInsert = true;
    EntityName = 'pagcustomer';
    EntitySetName = 'pagcustomers';
    PageType = API;
    SourceTable = Customer;
    DataAccessIntent = ReadOnly;
    Editable = false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(customerNo; Rec."No.")
                {
                    Caption = 'customerNo';
                }
                field(customerName; Rec.Name)
                {
                    Caption = 'customerName';
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'countryRegionCode';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(salespersonCode; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code';
                }
            }
        }
    }
}
