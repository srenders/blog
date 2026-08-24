report 70210 "Perf Report Nested Loops"
{
    Caption = 'Customer Summary (Nested Loops)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(CustomerNo; "No.")
            {
            }

            trigger OnPreDataItem()
            begin
                // DEMO: Intentionally inefficient - no SetLoadFields, loads full Customer records.
                CustomerCount := 0;
            end;

            trigger OnAfterGetRecord()
            var
                PerfDemoEntry: Record "Perf Demo Entry";
            begin
                // DEMO: Intentionally inefficient - CalcFields per Customer.
                CalcFields("Balance (LCY)");

                // DEMO: Nested loop simulated - query PerfDemoEntry per Customer (no SetLoadFields).
                PerfDemoEntry.Reset();
                PerfDemoEntry.SetRange("Customer No.", "No.");
                if PerfDemoEntry.FindSet() then
                    repeat
                        // Simulate processing each entry
                    until PerfDemoEntry.Next() = 0;

                if PerfDemoEntry.Count() > 0 then
                    CustomerCount += 1;
            end;

            trigger OnPostDataItem()
            begin
                GlobalCustomerCount := CustomerCount;
            end;
        }
    }

    var
        CustomerCount: Integer;
        GlobalCustomerCount: Integer;

    procedure GetCustomerCount(): Integer
    begin
        exit(GlobalCustomerCount);
    end;
}
