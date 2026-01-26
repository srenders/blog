codeunit 60114 "Tennis Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        this.SetupTennisManagement();
        this.InsertDefaultPlayers();
    end;

    local procedure SetupTennisManagement()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        // Create Number Series
        this.CreateNumberSeries('PLAYER', 'Tennis Players', 'TP0001', 'TP9999');
        this.CreateNumberSeries('MATCH', 'Tennis Matches', 'TM0001', 'TM9999');

        // Create the Tennis Setup record
        clear(TennisSetup);
        if not TennisSetup.get() then begin
            TennisSetup.Init();
            TennisSetup."Primary Key" := '';
            TennisSetup."Player Nos." := 'PLAYER';
            TennisSetup."Match Nos." := 'MATCH';
            TennisSetup.Insert();
        end;
    end;

    local procedure CreateNumberSeries(SeriesCode: Code[20]; Description: Text[100]; StartingNo: Code[20]; EndingNo: Code[20])
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        clear(NoSeries);
        clear(NoSeriesLine);
        if not NoSeries.Get(SeriesCode) then begin
            NoSeries.Init();
            NoSeries.Code := SeriesCode;
            NoSeries.Description := Description;
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := NoSeries.Code;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := StartingNo;
            NoSeriesLine."Ending No." := EndingNo;
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine.Insert();
        end;
    end;

    local procedure InsertDefaultPlayers()
    var
        TennisPlayer: Record "Tennis Player";
    begin
        // Check if we already have players
        clear(TennisPlayer);
        if not TennisPlayer.IsEmpty() then
            exit;

        // Insert sample players
        this.InsertPlayer('Roger Federer', DMY2Date(8, 8, 1981), '+41 123456789', 'roger@tennis.com');
        this.InsertPlayer('Rafael Nadal', DMY2Date(3, 6, 1986), '+34 987654321', 'rafael@tennis.com');
        this.InsertPlayer('Serena Williams', DMY2Date(26, 9, 1981), '+1 555123456', 'serena@tennis.com');
        this.InsertPlayer('Novak Djokovic', DMY2Date(22, 5, 1987), '+381 123456789', 'novak@tennis.com');
    end;

    local procedure InsertPlayer(PlayerName: Text[100]; BirthDate: Date; PhoneNo: Text[30]; Email: Text[80])
    var
        TennisPlayer: Record "Tennis Player";
        TennisSetup: Record "Tennis Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        clear(TennisPlayer);
        TennisPlayer.Init();
        TennisPlayer.Name := PlayerName;
        TennisPlayer."Date of Birth" := BirthDate;
        TennisPlayer."Phone No." := PhoneNo;
        TennisPlayer."E-Mail" := Email;
        if TennisSetup.Get() then begin
            TennisPlayer."No." := NoSeriesMgt.GetNextNo(TennisSetup."Player Nos.", WorkDate(), true);
            TennisPlayer.Insert(true);
        end;
    end;
}
