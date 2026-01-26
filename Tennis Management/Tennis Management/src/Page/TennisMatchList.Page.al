page 60108 "Tennis Match List"
{
    ApplicationArea = All;
    Caption = 'Tennis Match List';
    CardPageId = "Tennis Match Card";
    Editable = false;
    PageType = List;
    SourceTable = "Tennis Match";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the identification number of the tennis match.';
                }
                field("Match Date"; Rec."Match Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the match is played.';
                }
                field("Match Type"; Rec."Match Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of tennis match.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the tennis match.';
                }
                field("Court No."; Rec."Court No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the court number where the match is played.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Match")
            {
                Caption = '&Match';
                action("&Card")
                {
                    ApplicationArea = All;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Tennis Match Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the tennis match.';
                }
            }
        }
        area(processing)
        {
            action("&New")
            {
                ApplicationArea = All;
                Caption = '&New';
                Image = NewDocument;
                RunObject = Page "Tennis Match Card";
                RunPageMode = Create;
                ToolTip = 'Create a new tennis match.';
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("&New_Promoted"; "&New")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Match';

                actionref("&Card_Promoted"; "&Card")
                {
                }
            }
        }
    }

    views
    {
        view(AllMatches)
        {
            Caption = 'All Matches';
            OrderBy = ascending("Match Date");
        }
        view(CancelledMatches)
        {
            Caption = 'Cancelled Matches';
            Filters = where(Status = const("Cancelled"));
        }
        view(SinglesMatches)
        {
            Caption = 'Singles Matches';
            Filters = where("Match Type" = const("Singles"));
        }
        view(DoublesMatches)
        {
            Caption = 'Doubles Matches';
            Filters = where("Match Type" = const("Doubles"));
        }
    }
}
