tableextension 65122 SalesLine_Ext extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(65122; "Last Date Modified";DateTime)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
        }
    }
trigger OnAfterModify()
begin 
    "Last Date Modified" := CurrentDateTime;
    Modify();
end;    
}