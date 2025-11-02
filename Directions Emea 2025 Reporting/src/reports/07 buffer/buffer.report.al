report 70107 buffer
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Top 10 Customers Report';
    DefaultRenderingLayout = TopCustomersLayoutExcel;

    dataset
    {
        dataitem(CustomerProcessing; Customer)
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            begin
                // Clear buffer table before starting
                BufferTable.Reset();
                BufferTable.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "No.");

                // Calculate total sales for customer
                TotalAmount := GetTotalSalesAmount("No.");

                // Only process customers with sales
                if TotalAmount = 0 then
                    CurrReport.Skip();

                // Add to buffer table
                BufferTable.Init();
                BufferTable."Customer No." := "No.";
                BufferTable."Customer Name" := Name;
                BufferTable."Sales Amount" := TotalAmount;
                BufferTable.Insert();
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;
        }

        dataitem(Top10Buffer; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = filter(1 .. 10));

            column(RankNo; Top10Buffer.Number) { }
            column(CustomerNo; BufferTable."Customer No.") { }
            column(CustomerName; BufferTable."Customer Name") { }
            column(SalesAmount; BufferTable."Sales Amount") { }
            column(ReportTitle; ReportTitleLbl) { }


            trigger OnPreDataItem()
            begin
                // Sort buffer by sales amount descending
                BufferTable.Reset();
                BufferTable.SetCurrentKey("Sales Amount");
                BufferTable.Ascending(false);

                if not BufferTable.FindSet() then
                    CurrReport.Break();

                // Only show top 10 (or fewer if less than 10 exist)
                if BufferTable.Count < 10 then
                    Top10Buffer.SetRange(Number, 1, BufferTable.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number > 1 then
                    if BufferTable.Next() = 0 then
                        CurrReport.Break();
            end;
        }
    }

    rendering
    {
        layout(TopCustomersLayoutRDLC)
        {
            Type = RDLC;
            LayoutFile = './src/reports/07 buffer/TopCustomers.rdl';
            Caption = 'Top 10 Customers RDLC';
            Summary = 'Shows top 10 customers by sales RDLC';
        }
        layout(TopCustomersLayoutExcel)
        {
            Type = Excel;
            LayoutFile = './src/reports/07 buffer/TopCustomers.xlsx';
            Caption = 'Top 10 Customers Excel';
            Summary = 'Shows top 10 customers by sales Excel';
        }
    }

    trigger OnPreReport()
    begin
        Window.Open(ProcessingMsg);
    end;

    var
        BufferTable: Record "Customer Buffer" temporary;
        Window: Dialog;
        TotalAmount: Decimal;

        ReportTitleLbl: Label 'Top 10 Customers by Sales';
        PeriodLbl: Label 'Period: %1 to %2', Comment = '%1 = From Date, %2 = To Date';
        DateFilterErr: Label 'Please specify a date range.';
        DateRangeErr: Label 'From Date must be earlier than To Date.';
        ProcessingMsg: Label 'Processing customer #1...';

    local procedure GetTotalSalesAmount(CustomerNo: Code[20]): Decimal
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        TotalAmount: Decimal;
    begin
        // Get amounts from posted sales invoices
        SalesInvoiceLine.SetRange("Sell-to Customer No.", CustomerNo);
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
        //SalesInvoiceLine.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
        SalesInvoiceLine.CalcSums(Amount);
        TotalAmount := SalesInvoiceLine.Amount;

        exit(TotalAmount);
    end;
}