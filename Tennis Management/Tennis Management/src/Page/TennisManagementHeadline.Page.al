page 60110 "Tennis Management Headline"
{
    PageType = HeadlinePart;
    ApplicationArea = All;
    Caption = 'Tennis Management Headline';

    layout
    {
        area(content)
        {
            group(GreetingGroup)
            {
                ShowCaption = false;

                field(Greeting; this.GreetingText)
                {
                    ApplicationArea = All;
                    Caption = 'Greeting';
                    Editable = false;
                }
            }
            group(HeadlineGroup)
            {
                ShowCaption = false;

                field(Headline; this.HeadlineText)
                {
                    ApplicationArea = All;
                    Caption = 'Headline';
                    Editable = false;
                }
            }
        }
    }

    var
        GreetingText: Text;
        HeadlineText: Text;

    trigger OnOpenPage()
    begin
        this.SetGreeting();
        this.UpdateHeadlineText();
    end;

    local procedure SetGreeting()
    var
        UserSettings: Record "User Settings";
        UserName: Text;
        Hour: Integer;
        TheCurrentTime: Time;
    begin
        TheCurrentTime := Time();
        Hour := TheCurrentTime.Hour;  // Convert time (in milliseconds) to hours

        if UserSettings.Get(UserSecurityId()) then
            UserName := UserSettings."User ID";  // Corrected to get the actual User Name

        if UserName = '' then
            UserName := UserId;

        case true of
            Hour < 12:
                this.GreetingText := 'Good morning, ' + UserName;
            Hour < 18:
                this.GreetingText := 'Good afternoon, ' + UserName;
            else
                this.GreetingText := 'Good evening, ' + UserName;
        end;
    end;

    local procedure UpdateHeadlineText()
    begin
        this.HeadlineText := this.GetUpcomingMatchesHeadline();
    end;

    local procedure GetUpcomingMatchesHeadline() Result: Text
    var
        TennisMatch: Record "Tennis Match";
        MatchCount: Integer;
    begin
        TennisMatch.SetRange("Match Date", WorkDate(), CalcDate('<+7D>', WorkDate()));
        TennisMatch.SetRange(Status, TennisMatch.Status::Open);
        MatchCount := TennisMatch.Count;

        if MatchCount > 0 then
            Result := 'You have ' + Format(MatchCount) + ' upcoming tennis matches in the next 7 days.'
        else
            Result := 'You have no upcoming tennis matches scheduled for this week.';
    end;
}
