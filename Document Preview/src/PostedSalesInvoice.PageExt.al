/// <summary>
/// Page Extension for Posted Sales Invoice
/// Adds the Invoice Preview FactBox to display document preview
/// </summary>
pageextension 62100 "Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(InvoicePreviewPart; "Invoice Preview FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                Caption = 'Invoice Preview';
            }
        }
    }
}
