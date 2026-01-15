codeunit 61107 "Tennis API Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";
        IsInitialized: Boolean;

    [Test]
    procedure TestTennisPlayersAPIQuery()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayersAPI: Query "Tennis Players API";
        PlayerFound: Boolean;
    begin
        // [SCENARIO] Tennis Players API query returns player data correctly
        Initialize();

        // [GIVEN] Tennis Management setup and a player
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('API Test Player', Today(), '+1234567890', 'api@test.com');

        // [WHEN] Querying the Tennis Players API
        TennisPlayersAPI.Open();
        PlayerFound := false;
        while TennisPlayersAPI.Read() do
            if TennisPlayersAPI.playerNo = TennisPlayer."No." then begin
                PlayerFound := true;
                // [THEN] Player data should match
                if TennisPlayersAPI.playerName <> TennisPlayer.Name then
                    Error('API player name should match record');
                if TennisPlayersAPI.phoneNo <> TennisPlayer."Phone No." then
                    Error('API phone number should match record');
                if TennisPlayersAPI.email <> TennisPlayer."E-Mail" then
                    Error('API email should match record');
            end;
        TennisPlayersAPI.Close();

        if not PlayerFound then
            Error('Player should be found in API query');
    end;

    [Test]
    procedure TestTennisMatchesAPIQuery()
    var
        TennisMatch: Record "Tennis Match";
        TennisMatchesAPI: Query "Tennis Matches API";
        MatchFound: Boolean;
    begin
        // [SCENARIO] Tennis Matches API query returns match data correctly
        Initialize();

        // [GIVEN] Tennis Management setup and a match
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Doubles);
        TennisMatch."Court No." := 'Court 1';
        TennisMatch.Modify();

        // [WHEN] Querying the Tennis Matches API
        TennisMatchesAPI.Open();
        MatchFound := false;
        while TennisMatchesAPI.Read() do
            if TennisMatchesAPI.matchNo = TennisMatch."No." then begin
                MatchFound := true;
                // [THEN] Match data should match
                if TennisMatchesAPI.matchDate <> TennisMatch."Match Date" then
                    Error('API match date should match record');
                if TennisMatchesAPI.courtNo <> TennisMatch."Court No." then
                    Error('API court number should match record');
            end;
        TennisMatchesAPI.Close();

        if not MatchFound then
            Error('Match should be found in API query');
    end;

    [Test]
    procedure TestTennisMatchLinesAPIQuery()
    var
        TennisMatch: Record "Tennis Match";
        TennisPlayer: Record "Tennis Player";
        TennisMatchLine: Record "Tennis Match Line";
        TennisMatchLinesAPI: Query "Tennis Match Lines API";
        LineFound: Boolean;
    begin
        // [SCENARIO] Tennis Match Lines API query returns match line data correctly
        Initialize();

        // [GIVEN] Tennis Management setup, match, player and match line
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Line Test Player', Today(), '', '');
        TennisMatchLine := LibraryTennisTest.CreateTennisMatchLine(
            TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::B, true);

        // [WHEN] Querying the Tennis Match Lines API
        TennisMatchLinesAPI.Open();
        LineFound := false;
        while TennisMatchLinesAPI.Read() do
            if (TennisMatchLinesAPI.matchNo = TennisMatchLine."Match No.") and
               (TennisMatchLinesAPI.lineNo = TennisMatchLine."Line No.") then begin
                LineFound := true;
                // [THEN] Match line data should match
                if TennisMatchLinesAPI.playerNo <> TennisMatchLine."Player No." then
                    Error('API player number should match record');
                if TennisMatchLinesAPI.playerName <> TennisMatchLine."Player Name" then
                    Error('API player name should match record');
                if TennisMatchLinesAPI.winner <> TennisMatchLine.Winner then
                    Error('API winner flag should match record');
            end;
        TennisMatchLinesAPI.Close();

        if not LineFound then
            Error('Match line should be found in API query');
    end;

    [Test]
    procedure TestTennisPlayersAPIFlowFields()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisPlayersAPI: Query "Tennis Players API";
        PlayerFound: Boolean;
    begin
        // [SCENARIO] Tennis Players API query returns correct flow field values
        Initialize();

        // [GIVEN] Tennis Management setup, player and matches
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Flow Field Test Player', Today(), '', '');

        // Create two matches for the player
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, true);

        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);

        // [WHEN] Querying the Tennis Players API
        TennisPlayersAPI.Open();
        PlayerFound := false;
        while TennisPlayersAPI.Read() do
            if TennisPlayersAPI.playerNo = TennisPlayer."No." then begin
                PlayerFound := true;
                // [THEN] Flow fields should be calculated correctly
                if TennisPlayersAPI.totalMatches <> 2 then
                    Error('API total matches should be 2');
                if TennisPlayersAPI.matchesWon <> 1 then
                    Error('API matches won should be 1');
            end;
        TennisPlayersAPI.Close();

        if not PlayerFound then
            Error('Player should be found in API query');
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
    end;
}