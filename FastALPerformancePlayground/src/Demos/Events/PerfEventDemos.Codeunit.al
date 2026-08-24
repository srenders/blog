codeunit 70205 "Perf Event Demos"
{
    SingleInstance = true;
    procedure Bad_ModifyAllWithHiddenSubscriber(): Integer
    var
        PerfDemoEntry: Record "Perf Demo Entry";
    begin
        // DEMO: ModifyAll looks set-based, but subscribers can add per-row work.
        PerfDemoEntry.SetRange(Category, 'CAT1');
        PerfDemoEntry.ModifyAll("Is Open", false, true);
        exit(PerfDemoEntry.Count());
    end;

    procedure SetSubscriberEnabled(NewValue: Boolean)
    begin
        SubscriberEnabled := NewValue;
    end;

    procedure IsSubscriberEnabled(): Boolean
    begin
        exit(SubscriberEnabled);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Perf Demo Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure SlowSubscriber(var Rec: Record "Perf Demo Entry"; var xRec: Record "Perf Demo Entry"; RunTrigger: Boolean)
    var
        Customer: Record Customer;
    begin
        // DEMO: This subscriber intentionally adds per-record work. Do not optimize it away.
        if not SubscriberEnabled then
            exit;

        if Rec."Customer No." = '' then
            exit;

        Customer.SetLoadFields(Name);
        if Customer.Get(Rec."Customer No.") then;
    end;

    var
        SubscriberEnabled: Boolean;
}
