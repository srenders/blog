page 91107 "Simple Trans Minimal API"
{
    Caption = 'Simple Transaction API - Minimal Keys';
    PageType = API;
    APIPublisher = 'performance';
    APIGroup = 'performance';
    APIVersion = 'v1.0';
    EntityName = 'simpleTransactionMinimal';
    EntitySetName = 'simpleTransactionMinimal';
    SourceTable = "Simple Trans Minimal Keys";
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
