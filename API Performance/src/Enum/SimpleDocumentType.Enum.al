enum 91100 "Simple Document Type"
{
    Caption = 'Simple Document Type';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Invoice)
    {
        Caption = 'Invoice';
    }
    value(2; "Credit Memo")
    {
        Caption = 'Credit Memo';
    }
    value(3; Payment)
    {
        Caption = 'Payment';
    }
    value(4; Refund)
    {
        Caption = 'Refund';
    }
}