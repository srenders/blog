codeunit 61101 "Library - Tennis Test"
{
    procedure CreateTennisSetup(): Record "Tennis Setup"
    var
        TennisSetup: Record "Tennis Setup";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if TennisSetup.Get() then
            TennisSetup.Delete();

        // Create number series for players
        CreateNumberSeries('PLAYERS', 'Tennis Players', NoSeries, NoSeriesLine);

        // Create number series for matches  
        CreateNumberSeries('MATCHES', 'Tennis Matches', NoSeries, NoSeriesLine);

        TennisSetup.Init();
        TennisSetup."Primary Key" := '';
        TennisSetup."Player Nos." := 'PLAYERS';
        TennisSetup."Match Nos." := 'MATCHES';
        TennisSetup.Insert();

        exit(TennisSetup);
    end;

    procedure CreateTennisPlayer(PlayerName: Text[100]; DateOfBirth: Date; PhoneNo: Text[30]; Email: Text[80]): Record "Tennis Player"
    var
        TennisPlayer: Record "Tennis Player";
    begin
        TennisPlayer.Init();
        TennisPlayer.Insert(true);
        TennisPlayer.Name := PlayerName;
        TennisPlayer."Date of Birth" := DateOfBirth;
        TennisPlayer."Phone No." := PhoneNo;
        TennisPlayer."E-Mail" := Email;
        TennisPlayer.Modify();
        exit(TennisPlayer);
    end;

    procedure CreateTennisMatch(MatchDate: Date; MatchType: Enum "Tennis Match Type"): Record "Tennis Match"
    var
        TennisMatch: Record "Tennis Match";
    begin
        TennisMatch.Init();
        TennisMatch.Insert(true);
        TennisMatch."Match Date" := MatchDate;
        TennisMatch."Match Type" := MatchType;
        TennisMatch.Status := TennisMatch.Status::Open;
        TennisMatch.Modify();
        exit(TennisMatch);
    end;

    procedure CreateTennisMatchLine(MatchNo: Code[20]; LineNo: Integer; PlayerNo: Code[20]; Team: Enum "Tennis Match Team"; Winner: Boolean): Record "Tennis Match Line"
    var
        TennisMatchLine: Record "Tennis Match Line";
    begin
        TennisMatchLine.Init();
        TennisMatchLine."Match No." := MatchNo;
        TennisMatchLine."Line No." := LineNo;
        TennisMatchLine."Player No." := PlayerNo;
        TennisMatchLine.Team := Team;
        TennisMatchLine.Winner := Winner;
        TennisMatchLine.Insert(true);
        exit(TennisMatchLine);
    end;

    procedure FinishTennisMatch(var TennisMatch: Record "Tennis Match")
    begin
        TennisMatch.Status := TennisMatch.Status::Finished;
        TennisMatch.Modify();
    end;

    local procedure CreateNumberSeries(SeriesCode: Code[20]; Description: Text[100]; var NoSeries: Record "No. Series"; var NoSeriesLine: Record "No. Series Line")
    begin
        if NoSeries.Get(SeriesCode) then
            NoSeries.Delete(true);

        NoSeries.Init();
        NoSeries.Code := SeriesCode;
        NoSeries.Description := Description;
        NoSeries."Default Nos." := true;
        NoSeries."Manual Nos." := true;
        NoSeries.Insert();

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := SeriesCode;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine."Starting No." := CopyStr(SeriesCode + '0001', 1, 20);
        NoSeriesLine."Ending No." := CopyStr(SeriesCode + '9999', 1, 20);
        NoSeriesLine."Increment-by No." := 1;
        NoSeriesLine.Insert();
    end;
}