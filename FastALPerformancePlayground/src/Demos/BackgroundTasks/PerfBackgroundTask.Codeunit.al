codeunit 70207 "Perf Background Task"
{
    trigger OnRun()
    var
        Customer: Record Customer;
        Results: Dictionary of [Text, Text];
        TotalBalance: Decimal;
    begin
        Customer.SetLoadFields("No.");
        Customer.SetAutoCalcFields("Balance (LCY)");
        if Customer.FindSet() then
            repeat
                TotalBalance += Customer."Balance (LCY)";
            until Customer.Next() = 0;

        Results.Add('TotalBalance', Format(TotalBalance));
        Results.Add('CompletedAt', Format(CurrentDateTime()));
        Page.SetBackgroundTaskResult(Results);
    end;
}
