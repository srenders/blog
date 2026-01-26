page 60107 "Tennis Match Card"
{
    Caption = 'Tennis Match Card';
    PageType = Document;
    SourceTable = "Tennis Match";
    UsageCategory = Tasks;
    applicationarea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the match.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Match Date"; Rec."Match Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the match.';
                }
                field("Match Type"; Rec."Match Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this is a singles or doubles match.';
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the match.';
                }
                field("Court No."; Rec."Court No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the court number where this match is played.';
                }
            }
            part(PlayersSubform; "Tennis Match Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Match No." = field("No.");
            }
        }
    }
}
