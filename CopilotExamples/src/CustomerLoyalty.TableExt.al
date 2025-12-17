tableextension 50100 "Customer Loyalty Ext." extends Customer
{
    fields
    {
        field(50100; "Loyalty Score"; Integer)
        {
            trigger OnValidate()
            begin
                if ("Loyalty Score" < 0) or ("Loyalty Score" > 100) then
                    Error('Loyalty Score must be between 0 and 100.');
            end;
        }
    }
}