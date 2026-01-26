page 60111 "Tennis Management Activities"
{
    PageType = CardPart;
    ApplicationArea = All;
    Caption = 'Activities';

    layout
    {
        area(content)
        {
            cuegroup(PlayersCueGroup)
            {
                Caption = 'Players';

                field(ActivePlayers; this.ActivePlayersCount)
                {
                    ApplicationArea = All;
                    Caption = 'Active Players';
                    DrillDownPageId = "Tennis Player List";
                    ToolTip = 'Shows the number of active tennis players';
                }
            }
            cuegroup(MatchesCueGroup)
            {
                Caption = 'Matches';

                field(TodaysMatches; this.TodaysMatchesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Matches';
                    DrillDownPageId = "Tennis Match List";
                    
                }
                field(UpcomingMatches; this.UpcomingMatchesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Upcoming Matches (7 days)';
                    DrillDownPageId = "Tennis Match List";
                    ToolTip = 'Shows the number of upcoming tennis matches in the next 7 days';
                }
                field(CompletedMatches; this.CompletedMatchesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Completed Matches (This month)';
                    DrillDownPageId = "Tennis Match List";
                    ToolTip = 'Shows the number of completed tennis matches this month';
                }
            }
        }
    }

    var
        ActivePlayersCount: Integer;
        TodaysMatchesCount: Integer;
        UpcomingMatchesCount: Integer;
        CompletedMatchesCount: Integer;

    trigger OnOpenPage()
    begin
        this.LoadData();
    end;

    local procedure LoadData()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
    begin
        // Active players
        clear(this.ActivePlayersCount);
        TennisPlayer.Reset();
        if TennisPlayer.FindSet() then
            this.ActivePlayersCount := TennisPlayer.Count();

        // Today's matches
        clear(this.TodaysMatchesCount);
        TennisMatch.Reset();
        TennisMatch.SetRange("Match Date", WorkDate());
        if TennisMatch.FindSet() then
            this.TodaysMatchesCount := TennisMatch.Count();

        // Upcoming matches
        clear(this.UpcomingMatchesCount);
        TennisMatch.Reset();
        TennisMatch.SetRange("Match Date", CalcDate('<+1D>', WorkDate()), CalcDate('<+7D>', WorkDate()));
        TennisMatch.SetRange(Status, TennisMatch.Status::Open);
        if TennisMatch.FindSet() then
            this.UpcomingMatchesCount := TennisMatch.Count();

        // Completed matches this month
        clear(this.CompletedMatchesCount);
        TennisMatch.Reset();
        TennisMatch.SetRange("Match Date", CalcDate('<-CM>', WorkDate()), WorkDate());
        TennisMatch.SetRange(Status, TennisMatch.Status::Finished);
        if TennisMatch.FindSet() then
            this.CompletedMatchesCount := TennisMatch.Count();
    end;
}
