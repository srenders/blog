page 70200 "Perf Demo Results"
{
    PageType = ListPart;
    SourceTable = "Perf Demo Result";
    Caption = 'Measurements';
    Editable = false;
    ApplicationArea = All;
    SourceTableView = sorting("Demo Code", "Run No.");

    layout
    {
        area(Content)
        {
            repeater(Results)
            {
                field("Demo Code"; Rec."Demo Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifies the demonstration.';
                }
                field("Run No."; Rec."Run No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifies the repeated run for this demonstration.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifies the implementation that was measured.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows elapsed execution duration.';
                }
                field("SQL Statements"; Rec."SQL Statements")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows SQL statements executed during the demo.';
                }
                field("Rows Read"; Rec."Rows Read")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows SQL rows read during the demo.';
                }
                field("Result Value"; Rec."Result Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the value returned by the demo for equivalence checks.';
                }
                field("Last Run At"; Rec."Last Run At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows when this run was recorded.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows teaching notes for the implementation.';
                }
            }
        }
    }
}
