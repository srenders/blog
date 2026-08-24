page 70203 "Perf Page Performance Good"
{
    PageType = List;
    SourceTable = "Perf Demo Entry";
    Caption = 'Page Performance - Good';
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
                    ToolTip = 'Shows the playground amount without extra trigger work.';
                }
            }
        }
    }
}
