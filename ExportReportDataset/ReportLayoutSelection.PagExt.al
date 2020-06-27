pageextension 50100 ReportLayoutSelection extends "Report Layout Selection" //9652
{
    actions
    {
        addlast(processing)
        {
            action(ExportDataset)
            {
                Caption = 'Export Dataset';
                ApplicationArea = All;
                Image = Export;

                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileManagement: Codeunit "File Management";
                    reportParameters: text;
                    OutStr: OutStream;
                begin
                    reportParameters := Report.RunRequestPage(Rec."Report ID");
                    TempBlob.CreateOutStream(OutStr);
                    Report.SaveAs(Rec."Report ID", reportParameters, ReportFormat::Xml, OutStr);
                    FileManagement.BLOBExport(TempBlob, format(rec."Report ID") + '_' + rec."Report Name" + '.xml', true);
                end;
            }
        }
    }
}