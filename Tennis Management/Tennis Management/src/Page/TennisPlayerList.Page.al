page 60105 "Tennis Player List"
{
    ApplicationArea = All;
    Caption = 'Tennis Players';
    PageType = List;
    SourceTable = "Tennis Player";
    UsageCategory = Lists;
    CardPageId = "Tennis Player Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the player.';
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
            }
        }
    }
}
