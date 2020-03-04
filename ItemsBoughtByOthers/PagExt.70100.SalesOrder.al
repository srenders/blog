pageextension 70100 SalesOrderExt extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(ApprovalFactBox)
        {
            part(ItemCrossSaleFactbox; "Item Cross Sale Factbox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Document Type" = field("Document Type")
                                , "Document No." = field("Document No.")
                                , "Line No." = field("Line No.")
                                , Type = field(Type)
                                , "No." = field("No.");
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}