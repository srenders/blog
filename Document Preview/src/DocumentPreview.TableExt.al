/// <summary>
/// Table Extension for Sales Invoice Header to add document preview capability
/// Demonstrates the ExtendedDatatype = Document feature in BC v27
/// </summary>
tableextension 62100 "Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        /// <summary>
        /// Media field to store the invoice preview image
        /// ExtendedDatatype = Document enables portrait-optimized rendering in FactBoxes
        /// </summary>
        field(50100; "Invoice Preview"; Media)
        {
            Caption = 'Invoice Preview';
            DataClassification = CustomerContent;
            ExtendedDatatype = Document;
        }
    }
}
