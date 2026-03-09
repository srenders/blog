page 80200 ValueEntries
{
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'valueentriespage';
    EntitySetName = 'valueentriespage';
    DataAccessIntent = ReadOnly;
    Editable = false;
    PageType = API;
    SourceTable = "Value Entry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(itemLedgerEntryType; Rec."Item Ledger Entry Type")
                {
                    Caption = 'Item Ledger Entry Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(sourceNo; Rec."Source No.")
                {
                    Caption = 'Source No.';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Source No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(salesAmountActual; Rec."Sales Amount (Actual)")
                {
                    Caption = 'Sales Amount (Actual)';
                }
                field(valuedQuantity; Rec."Valued Quantity")
                {
                    Caption = 'Valued Quantity';
                }
            }
        }
    }
}
