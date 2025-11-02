table 70107 "Customer Buffer"
{
    Caption = 'Customer Buffer';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(2; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(3; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
            DecimalPlaces = 2 : 2;
        }
    }

    keys
    {
        key(PK; "Customer No.")
        {
            Clustered = true;
        }
        key(SalesAmount; "Sales Amount")
        {
        }
    }
}