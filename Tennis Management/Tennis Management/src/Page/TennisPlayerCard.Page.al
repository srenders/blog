page 60104 "Tennis Player Card"
{
    Caption = 'Tennis Player Card';
    PageType = Card;
    SourceTable = "Tennis Player";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the player.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the tennis player.';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of birth of the tennis player.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the phone number of the tennis player.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address of the tennis player.';
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field("Total Matches"; Rec."Total Matches")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of matches played by this player.';
                }
                field("Matches Won"; Rec."Matches Won")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of matches won by this player.';
                }
                field("Matches Lost"; Rec."Matches Lost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of matches lost by this player.';
                }
            }
        }
    }
}
