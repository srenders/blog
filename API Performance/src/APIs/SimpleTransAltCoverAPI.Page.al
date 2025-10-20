page 91108 "Simple Trans Alt Cover API"
{
    Caption = 'Simple Transaction API - Alternative Covering';
    PageType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionAltCover';
    EntitySetName = 'simpleTransactionAltCover';
    SourceTable = "Simple Trans Alt Covering";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    DataAccessIntent = ReadOnly;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }

                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }

                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }

                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }

                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }

                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }

                field(amountLCY; Rec."Amount (LCY)")
                {
                    Caption = 'Amount (LCY)';
                }
            }
        }
    }
}
