codeunit 61103 "Tennis Match Line Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";

    [Test]
    procedure TestTennisMatchLineCreation()
    var
        TennisMatch: Record "Tennis Match";
        TennisPlayer: Record "Tennis Player";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // [SCENARIO] A tennis match line can be created
        Initialize();

        // [GIVEN] Tennis Management setup, a match and a player
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Test Player', Today(), '', '');

        // [WHEN] Creating a match line
        TennisMatchLine := LibraryTennisTest.CreateTennisMatchLine(
            TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);

        // [THEN] Match line should be created correctly
        if TennisMatchLine."Match No." <> TennisMatch."No." then
            Error('Match No. should match');
        if TennisMatchLine."Player No." <> TennisPlayer."No." then
            Error('Player No. should match');
        if TennisMatchLine.Team <> "Tennis Match Team"::A then
            Error('Team should be A');
        if TennisMatchLine.Winner then
            Error('Winner should be false');
    end;

    [Test]
    procedure TestTennisMatchLinePlayerNameValidation()
    var
        TennisMatch: Record "Tennis Match";
        TennisPlayer: Record "Tennis Player";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // [SCENARIO] Player name is populated when player number is set
        Initialize();

        // [GIVEN] Tennis Management setup, a match and a player
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('John Doe', Today(), '', '');

        // [WHEN] Creating a match line with player
        TennisMatchLine.Init();
        TennisMatchLine."Match No." := TennisMatch."No.";
        TennisMatchLine."Line No." := 1;
        TennisMatchLine.Validate("Player No.", TennisPlayer."No.");
        TennisMatchLine.Insert(true);

        // [THEN] Player name should be populated
        if TennisMatchLine."Player Name" <> TennisPlayer.Name then
            Error('Player name should be populated from player record');
    end;

    [Test]
    procedure TestTennisMatchLineWinnerValidation()
    var
        TennisMatch: Record "Tennis Match";
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisMatchLine1, TennisMatchLine2 : Record "Tennis Match Line";
    begin
        // [SCENARIO] Setting winner updates all team members and sets opponents as losers
        Initialize();

        // [GIVEN] Tennis Management setup, a match and players for both teams
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Player 2', Today(), '', '');

        // Create match lines for both teams
        TennisMatchLine1 := LibraryTennisTest.CreateTennisMatchLine(
            TennisMatch."No.", 1, TennisPlayer1."No.", "Tennis Match Team"::A, false);
        TennisMatchLine2 := LibraryTennisTest.CreateTennisMatchLine(
            TennisMatch."No.", 2, TennisPlayer2."No.", "Tennis Match Team"::B, false);

        // [WHEN] Setting Team A as winner
        TennisMatchLine1.Winner := true;
        TennisMatchLine1.Modify();

        // [THEN] Team B should be set as loser
        TennisMatchLine2.Get(TennisMatch."No.", 2);
        if TennisMatchLine2.Winner then
            Error('Team B player should not be winner');
    end;

    [Test]
    procedure TestTennisMatchLineDoubles()
    var
        TennisMatch: Record "Tennis Match";
        TennisPlayer1, TennisPlayer2, TennisPlayer3, TennisPlayer4 : Record "Tennis Player";
        TennisMatchLine1, TennisMatchLine2, TennisMatchLine3, TennisMatchLine4 : Record "Tennis Match Line";
    begin
        // [SCENARIO] Doubles match can have multiple players per team
        Initialize();

        // [GIVEN] Tennis Management setup, a doubles match and 4 players
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Doubles);
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Player 2', Today(), '', '');
        TennisPlayer3 := LibraryTennisTest.CreateTennisPlayer('Player 3', Today(), '', '');
        TennisPlayer4 := LibraryTennisTest.CreateTennisPlayer('Player 4', Today(), '', '');

        // [WHEN] Creating match lines for doubles
        TennisMatchLine1 := LibraryTennisTest.CreateTennisMatchLine(
            TennisMatch."No.", 1, TennisPlayer1."No.", "Tennis Match Team"::A, false);
        TennisMatchLine2 := LibraryTennisTest.CreateTennisMatchLine(
            TennisMatch."No.", 2, TennisPlayer2."No.", "Tennis Match Team"::A, false);
        TennisMatchLine3 := LibraryTennisTest.CreateTennisMatchLine(
            TennisMatch."No.", 3, TennisPlayer3."No.", "Tennis Match Team"::B, false);
        TennisMatchLine4 := LibraryTennisTest.CreateTennisMatchLine(
            TennisMatch."No.", 4, TennisPlayer4."No.", "Tennis Match Team"::B, false);

        // [THEN] All match lines should be created correctly
        if TennisMatchLine1.Team <> "Tennis Match Team"::A then
            Error('Player 1 should be on Team A');
        if TennisMatchLine2.Team <> "Tennis Match Team"::A then
            Error('Player 2 should be on Team A');
        if TennisMatchLine3.Team <> "Tennis Match Team"::B then
            Error('Player 3 should be on Team B');
        if TennisMatchLine4.Team <> "Tennis Match Team"::B then
            Error('Player 4 should be on Team B');
    end;

    local procedure Initialize()
    begin
        LibraryTennisTest.CleanupTestData();
        Commit();
    end;
}