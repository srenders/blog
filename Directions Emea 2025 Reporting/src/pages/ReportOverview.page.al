page 70120 "Report Overview"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Report Overview - Directions EMEA 2025';
    SourceTable = AllObjWithCaption;
    SourceTableView = where("Object Type" = const(Report), "Object ID" = filter(50000 .. 99999));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Reports)
            {
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The ID of the report';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The name of the report';
                }
                field("Object Caption"; Rec."Object Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'The caption of the report';
                }
                field(HasLayout; HasReportLayout(Rec."Object ID"))
                {
                    ApplicationArea = All;
                    Caption = 'Has Layout';
                    ToolTip = 'Indicates if the report has a layout defined';
                }
            }
        }
        area(FactBoxes)
        {
            part(Attachments; "Report PDF Attachment Factbox")
            {
                ApplicationArea = All;
            }
        }
    }



    actions
    {
        area(Processing)
        {
            action(PreviewReport)
            {
                ApplicationArea = All;
                Caption = 'Generate (PDF)';
                ToolTip = 'Generate PDF preview of the selected report in the factbox';
                Image = Report;

                trigger OnAction()
                begin
                    PreviewSelectedReport();
                end;
            }
            action(RunReport)
            {
                ApplicationArea = All;
                Caption = 'Run Report';
                ToolTip = 'Run the selected report with the standard report viewer';
                Image = ExecuteBatch;

                trigger OnAction()
                begin
                    if Rec."Object ID" = 0 then
                        exit;
                    Report.Run(Rec."Object ID");
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(PreviewReport_Promoted; PreviewReport) { }
                actionref(RunReport_Promoted; RunReport) { }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        UpdateAttachmentFilter();
    end;

    local procedure HasReportLayout(ReportID: Integer): Boolean
    var
        ReportLayoutList: Record "Report Layout List";
    begin
        // Check if there are any layouts (built-in or custom) defined for this report
        ReportLayoutList.SetRange("Report ID", ReportID);
        exit(not ReportLayoutList.IsEmpty());
    end;

    local procedure PreviewSelectedReport()
    var
        ReportPDFAttachment: Codeunit "Report PDF Attachment";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        InStr: InStream;
        OutStr: OutStream;
        FileName: Text;
    begin
        if Rec."Object ID" = 0 then
            exit;

        // Check if report has a layout
        if not HasReportLayout(Rec."Object ID") then
            exit;

        // Create output stream for PDF
        TempBlob.CreateOutStream(OutStr);

        // Render the report to PDF - this will show request page if needed
        if Report.SaveAs(Rec."Object ID", '', ReportFormat::Pdf, OutStr, RecRef) then begin
            // Check if we have data
            if not TempBlob.HasValue() then
                exit;

            // Attach PDF as document attachment
            TempBlob.CreateInStream(InStr);
            FileName := Rec."Object Caption" + '.pdf';
            ReportPDFAttachment.AttachPDFToReport(Rec."Object ID", InStr, FileName);

            // Force factbox refresh
            CurrPage.Update(false);
        end;
    end;

    local procedure UpdateAttachmentFilter()
    begin
        // Filter the factbox to show only attachments for the currently selected report
        CurrPage.Attachments.Page.SetFilterByReportID(Rec."Object ID");
    end;
}
