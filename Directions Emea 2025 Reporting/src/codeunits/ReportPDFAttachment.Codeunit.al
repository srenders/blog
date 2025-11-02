codeunit 70123 "Report PDF Attachment"
{
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', true, true)]
    local procedure HandleInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
    begin
        if RecRef.Number = Database::"Report PDF Storage" then begin
            FieldRef := RecRef.Field(1); // Report ID field
            DocumentAttachment."Table ID" := Database::"Report PDF Storage";
            DocumentAttachment."No." := Format(FieldRef.Value);
        end;
    end;

    procedure AttachPDFToReport(ReportID: Integer; var PDFInStream: InStream; FileName: Text)
    var
        PDFStorage: Record "Report PDF Storage";
        DocumentAttachment: Record "Document Attachment";
        RecRef: RecordRef;
    begin
        // Ensure the storage record exists
        if not PDFStorage.Get(ReportID) then begin
            PDFStorage.Init();
            PDFStorage."Report ID" := ReportID;
            PDFStorage.Insert();
        end;

        // Delete existing PDF attachment for this report
        DocumentAttachment.SetRange("Table ID", Database::"Report PDF Storage");
        DocumentAttachment.SetRange("No.", Format(ReportID));
        DocumentAttachment.DeleteAll(true);

        // Create new attachment and import the PDF first
        RecRef.GetTable(PDFStorage);
        DocumentAttachment.InitFieldsFromRecRef(RecRef);
        DocumentAttachment."File Name" := CopyStr(FileName, 1, 250);
        DocumentAttachment."File Extension" := 'pdf';
        DocumentAttachment.Validate("Attached Date", CurrentDateTime);

        // Import the PDF BEFORE inserting the record
        DocumentAttachment."Document Reference ID".ImportStream(PDFInStream, FileName, 'application/pdf');

        // Now insert the record with the media already attached
        DocumentAttachment.Insert(true);
    end;

    procedure ViewPDFAttachment(ReportID: Integer)
    var
        DocumentAttachment: Record "Document Attachment";
        TenantMedia: Record "Tenant Media";
        InStr: InStream;
    begin
        DocumentAttachment.SetRange("Table ID", Database::"Report PDF Storage");
        DocumentAttachment.SetRange("No.", Format(ReportID));
        if not DocumentAttachment.FindFirst() then
            Error('No PDF preview available for this report. Please use "Preview Report" first.');

        if not TenantMedia.Get(DocumentAttachment."Document Reference ID".MediaId) then
            Error('PDF content not found. Please generate a new preview.');

        TenantMedia.Content.CreateInStream(InStr);
        File.ViewFromStream(InStr, DocumentAttachment."File Name");
    end;
}
