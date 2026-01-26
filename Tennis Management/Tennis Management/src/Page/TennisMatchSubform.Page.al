page 60106 "Tennis Match Subform"
{
    Caption = 'Players';
    PageType = ListPart;
    SourceTable = "Tennis Match Line";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Player No."; Rec."Player No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the player participating in this match.';
                }
                field("Player Name"; Rec."Player Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the player participating in this match.';
                }
                field(Team; Rec.Team)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which team the player belongs to in this match.';
                }
                field(Winner; Rec.Winner)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this player won the match.';
                }
            }
        }
    }
}
