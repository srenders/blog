page 70202 "Perf Page Performance Bad"
{
    PageType = List;
    SourceTable = "Perf Demo Entry";
    Caption = 'Page Performance - Bad';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Entries)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the playground entry number.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the playground category.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the playground amount.';
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ToolTip = 'Shows the customer name loaded by the deliberately expensive trigger.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        // DEMO: Deliberately expensive per-row work. Do not move this pattern into production pages.
        Customer.SetLoadFields(Name);
        if Customer.Get(Rec."Customer No.") then begin
            Customer.CalcFields("Balance (LCY)");
            CustomerName := Customer.Name;
        end;
    end;

    var
        CustomerName: Text[100];
}
