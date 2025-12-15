/// <summary>
/// FactBox page to display invoice preview
/// Uses temporary table to avoid storing images in database
/// Generates preview on-demand when viewing invoice
/// </summary>
page 62100 "Invoice Preview FactBox"
{
    PageType = CardPart;
    SourceTable = "Sales Invoice Header";
    SourceTableTemporary = true;
    Caption = 'Invoice Preview';
    Permissions = tabledata "Sales Invoice Header" = rimd;

    layout
    {
        area(Content)
        {
            field("Invoice Preview"; Rec."Invoice Preview")
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Shows a preview of the posted sales invoice report.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if not Rec."Invoice Preview".HasValue then begin
            GeneratePreview();
            CurrPage.Update(false);
        end;
    end;

    /// <summary>
    /// Generates a preview image of the invoice by:
    /// 1. Rendering the invoice report to PDF
    /// 2. Converting first page of PDF to PNG image
    /// 3. Importing the image into the Media field
    /// </summary>
    local procedure GeneratePreview()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PDFDocument: Codeunit "PDF Document";
        TempBlobImage: Codeunit "Temp Blob";
        TempBlobPDF: Codeunit "Temp Blob";
        InStrImage: InStream;
        InStrPDF: InStream;
        OutStr: OutStream;
        FileName: Text;
    begin
        if Rec."No." = '' then
            exit;

        // Set filter on the record for report
        SalesInvoiceHeader.SetRange("No.", Rec."No.");
        if not SalesInvoiceHeader.FindFirst() then
            exit;

        FileName := StrSubstNo('Invoice_%1.png', Rec."No.");

        // Save report as PDF to TempBlob with proper record filter
        TempBlobPDF.CreateOutStream(OutStr);
        Report.SaveAs(Report::"Standard Sales - Invoice", '', ReportFormat::Pdf, OutStr, SalesInvoiceHeader);

        // Load PDF and convert to image
        TempBlobPDF.CreateInStream(InStrPDF);
        PDFDocument.Load(InStrPDF);

        // Convert first page of PDF to PNG image
        TempBlobImage.CreateOutStream(OutStr);
        TempBlobImage.CreateInStream(InStrImage);
        PDFDocument.ConvertToImage(InStrImage, Enum::"Image Format"::Png, 1);

        // Import image to Media field
        if Rec.Get(Rec."No.") then begin
            Clear(Rec."Invoice Preview");
            Rec."Invoice Preview".ImportStream(InStrImage, FileName, 'image/png');
            Rec.Modify(true);
        end;
    end;
}
