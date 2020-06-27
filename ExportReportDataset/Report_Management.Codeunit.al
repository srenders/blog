codeunit 50100 Report_Management
{
    procedure ExportReportDataset(Report_ID: Integer)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        reportParameters: text;
        OutStr: OutStream;
    begin
        reportParameters := Report.RunRequestPage(Report_ID);
        TempBlob.CreateOutStream(OutStr);
        Report.SaveAs(Report_ID, reportParameters, ReportFormat::Xml, OutStr);
        FileManagement.BLOBExport(TempBlob, format(Report_ID) + '_' + '.xml', true);
    end;
    procedure GetNumberFromString(String : Text) : integer
    var
        StringPart: Text;
        TypeHelper: Codeunit "Type Helper";
        LoopNo: Integer;
        ReportName: Text;
        ReportID: Integer;
    begin
        for LoopNo := 1 to StrLen(String) do begin
            StringPart := CopyStr(String, LoopNo, 1);
            if TypeHelper.IsNumeric(StringPart) then
                reportName += StringPart;
        end;
        Evaluate(ReportID, ReportName);
        exit(ReportID);
    end;
}