codeunit 70203 "Perf FlowField Demos"
{
    procedure Bad_CalcFieldsInLoop(): Decimal
    var
        Customer: Record Customer;
        TotalBalance: Decimal;
    begin
        // DEMO: Intentionally recalculates the FlowField for every Customer.
        Customer.SetLoadFields("No.", Name);
        if Customer.FindSet() then
            repeat
                Customer.CalcFields("Balance (LCY)");
                TotalBalance += Customer."Balance (LCY)";
            until Customer.Next() = 0;
        exit(TotalBalance);
    end;

    procedure Good_SetAutoCalcFields(): Decimal
    var
        Customer: Record Customer;
        TotalBalance: Decimal;
    begin
        Customer.SetLoadFields("No.", Name);
        Customer.SetAutoCalcFields("Balance (LCY)");
        if Customer.FindSet() then
            repeat
                TotalBalance += Customer."Balance (LCY)";
            until Customer.Next() = 0;
        exit(TotalBalance);
    end;
}
