query 65123 qryDateFormulasInPowerBI
{
    QueryType = Normal;

    elements
    {
        dataitem(Customer; Customer)
        {
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(ShippingTime; "Shipping Time")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
