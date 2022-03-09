reportextension 50102 StandardSalesInvoice extends "Standard Sales - Invoice"
{
    RDLCLayout = './src/StandardSalesInvoiceExtended.rdlc';

    dataset
    {
        // Add changes to dataitems and columns here
        add(Line)
        {
            column(Order_No_Line_Lbl; Line.fieldCaption("Order No."))
            { }
            column(Order_No_Line; Line."Order No.")
            { }
            column(DisplayOrderInfo; DisplayOrderInfo)
            { }
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
        layout
        {
            addlast(Options)
            {
                field(DisplayOrderInfo; DisplayOrderInfo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Order Information';
                    ToolTip = 'Specifies if you want Order Information to be shown on the document.';
                }
            }
        }
    }
    var
        DisplayOrderInfo: Boolean;
}