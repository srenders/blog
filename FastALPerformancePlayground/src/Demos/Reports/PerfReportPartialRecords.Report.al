report 70211 "Perf Report Partial Records"
{
    Caption = 'Customer Summary (Optimized)';
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
            column(CustomerName; Name)
            {
            }
            column(Balance; "Balance (LCY)")
            {
            }
            column(EntryTotal; EntryTotal)
            {
            }

            trigger OnPreDataItem()
            var
                PerfDemoEntry: Record "Perf Demo Entry";
                TempCustomerNos: Record Customer temporary;
            begin
                // DEMO: Optimized - pre-filter to only customers with entries.
                PerfDemoEntry.SetCurrentKey("Customer No.");
                if PerfDemoEntry.FindSet() then
                    repeat
                        if not TempCustomerNos.Get(PerfDemoEntry."Customer No.") then begin
                            TempCustomerNos."No." := PerfDemoEntry."Customer No.";
                            TempCustomerNos.Insert();
                        end;
                    until PerfDemoEntry.Next() = 0;

                // Build filter for customers with entries.
                CustomerFilter := '';
                if TempCustomerNos.FindSet() then
                    repeat
                        if CustomerFilter <> '' then
                            CustomerFilter += '|';
                        CustomerFilter += TempCustomerNos."No.";
                    until TempCustomerNos.Next() = 0;

                if CustomerFilter <> '' then
                    SetFilter("No.", CustomerFilter);

                // DEMO: Optimized - load only needed fields.
                SetLoadFields("No.", Name);
                SetAutoCalcFields("Balance (LCY)");

                CustomerCount := 0;
            end;

            trigger OnAfterGetRecord()
            var
                PerfDemoEntry: Record "Perf Demo Entry";
            begin
                // DEMO: Balance loaded via SetAutoCalcFields (no per-record CalcFields).

                // DEMO: Efficient aggregate using CalcSums instead of nested loop.
                PerfDemoEntry.SetRange("Customer No.", "No.");
                PerfDemoEntry.SetLoadFields(Amount);
                PerfDemoEntry.CalcSums(Amount);
                EntryTotal := PerfDemoEntry.Amount;

                CustomerCount += 1;
            end;

            trigger OnPostDataItem()
            begin
                GlobalCustomerCount := CustomerCount;
            end;
        }
    }

    var
        EntryTotal: Decimal;
        CustomerCount: Integer;
        GlobalCustomerCount: Integer;
        CustomerFilter: Text;

    procedure GetCustomerCount(): Integer
    begin
        exit(GlobalCustomerCount);
    end;
}
