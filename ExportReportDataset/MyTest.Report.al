report 50100 MyTestReport
{
    Caption = 'MyTestReport';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'MyTestReport.rdl';


    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No; "No.")
            { }
            column(Name; Name)
            { }
            column(City; City)
            { }
            column(County; County)
            { }
            column(SalespersonCode; "Salesperson Code")
            { }
            column(SalesLCY; "Sales (LCY)")
            { }
            column(BalanceLCY; "Balance (LCY)")
            { }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(ExportDataset; ExportDataset)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    var
        ExportDataset: Boolean;

    trigger OnPostReport()
    var
        Report_Management: Codeunit Report_Management;
        ReportID: Integer;
    begin
        if not ExportDataset then exit;
        ReportID := Report_Management.GetNumberFromString(CurrReport.ObjectId(false));
        Report_Management.ExportReportDataset(ReportID);
    end;
}