codeunit 61114 "Tennis Integration Test Runner"
{
    Subtype = TestRunner;

    // Integration test runner for Tennis Management - tests cross-component scenarios using TestRunner subtype

    trigger OnRun()
    begin
        // Execute integration test suite
        RunIntegrationTestSuite();
    end;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";
        IsInitialized: Boolean;
        RankingPlayerTxt: Label 'Ranking Player %1';
        DateFormulaTxt: Label '+%1D';

    local procedure RunIntegrationTestSuite()
    begin
        // [SCENARIO] Execute integration test suite for cross-component functionality
        Initialize();

        // Run integration tests
        IntegrationTest_CompleteMatchFlow();
        IntegrationTest_MultiPlayerTournament();
        IntegrationTest_DataMigrationScenario();
        IntegrationTest_APIIntegration();
        IntegrationTest_ReportGeneration();
    end;

    local procedure IntegrationTest_CompleteMatchFlow()
    begin
        // [SCENARIO] Test complete match flow from setup to completion
        Initialize();

        TestCompleteMatchLifecycle();
    end;

    local procedure IntegrationTest_MultiPlayerTournament()
    begin
        // [SCENARIO] Test multi-player tournament scenario
        Initialize();

        TestTournamentWithMultiplePlayers();
        TestTournamentRanking();
    end;

    local procedure IntegrationTest_DataMigrationScenario()
    begin
        // [SCENARIO] Test data migration and bulk operations
        Initialize();

        TestBulkPlayerImport();
        TestBulkMatchCreation();
        TestDataExport();
    end;

    local procedure IntegrationTest_APIIntegration()
    begin
        // [SCENARIO] Test API integration scenarios
        Initialize();

        TestPlayerAPIScenarios();
        TestMatchAPIScenarios();
    end;

    local procedure IntegrationTest_ReportGeneration()
    begin
        // [SCENARIO] Test report generation with real data
        Initialize();

        TestPlayerReports();
        TestMatchReports();
        TestStatisticsReports();
    end;

    local procedure TestCompleteMatchLifecycle()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // [SCENARIO] Complete match lifecycle: Setup -> Players -> Match -> Play -> Results

        // Step 1: Setup system
        LibraryTennisTest.CreateTennisSetup();

        // Step 2: Create players
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Integration Player 1', Today(), '+1-555-0001', 'player1@test.com');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Integration Player 2', Today(), '+1-555-0002', 'player2@test.com');

        // Step 3: Create match
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);

        // Step 4: Assign players to match
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer1."No.", "Tennis Match Team"::A, false);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 2, TennisPlayer2."No.", "Tennis Match Team"::B, false);

        // Step 5: Verify match is ready to play
        VerifyMatchReadiness(TennisMatch."No.");

        // Step 6: Play match (set winner)
        TennisMatchLine.Get(TennisMatch."No.", 1);
        TennisMatchLine.Winner := true;
        TennisMatchLine.Modify();

        // Step 7: Complete match
        TennisMatch.Get(TennisMatch."No.");
        TennisMatch.Status := "Tennis Match Status"::Finished;
        TennisMatch.Modify();

        // Step 8: Verify final state
        VerifyCompletedMatch(TennisMatch."No.");
    end;

    local procedure TestTournamentWithMultiplePlayers()
    var
        TennisPlayer: array[8] of Record "Tennis Player";
        TennisMatch: array[4] of Record "Tennis Match";
        PlayerNames: array[8] of Text;
        i: Integer;
    begin
        // [SCENARIO] Tournament with 8 players, 4 matches

        LibraryTennisTest.CreateTennisSetup();

        // Create 8 players
        PlayerNames[1] := 'Tournament Player 1';
        PlayerNames[2] := 'Tournament Player 2';
        PlayerNames[3] := 'Tournament Player 3';
        PlayerNames[4] := 'Tournament Player 4';
        PlayerNames[5] := 'Tournament Player 5';
        PlayerNames[6] := 'Tournament Player 6';
        PlayerNames[7] := 'Tournament Player 7';
        PlayerNames[8] := 'Tournament Player 8';

        for i := 1 to 8 do
            TennisPlayer[i] := LibraryTennisTest.CreateTennisPlayer(PlayerNames[i], Today(), '', '');

        // Create 4 matches (each with 2 players)
        for i := 1 to 4 do begin
            TennisMatch[i] := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
            LibraryTennisTest.CreateTennisMatchLine(TennisMatch[i]."No.", 1, TennisPlayer[(i * 2) - 1]."No.", "Tennis Match Team"::A, false);
            LibraryTennisTest.CreateTennisMatchLine(TennisMatch[i]."No.", 2, TennisPlayer[i * 2]."No.", "Tennis Match Team"::B, false);
        end;

        // Verify tournament structure
        VerifyTournamentStructure(TennisMatch);
    end;

    local procedure TestTournamentRanking()
    var
        TennisPlayer: array[4] of Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
        i: Integer;
        WinCount: Integer;
    begin
        // [SCENARIO] Test tournament ranking calculation

        LibraryTennisTest.CreateTennisSetup();

        // Create 4 players
        for i := 1 to 4 do
            TennisPlayer[i] := LibraryTennisTest.CreateTennisPlayer(StrSubstNo(RankingPlayerTxt, i), Today(), '', '');

        // Create matches with different winners
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer[1]."No.", "Tennis Match Team"::A, true);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 2, TennisPlayer[2]."No.", "Tennis Match Team"::B, false);

        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer[1]."No.", "Tennis Match Team"::A, true);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 2, TennisPlayer[3]."No.", "Tennis Match Team"::B, false);

        // Verify Player 1 has 2 wins
        WinCount := CalculatePlayerWins(TennisPlayer[1]."No.");
        if WinCount <> 2 then
            Error('Player 1 should have 2 wins, but has %1', WinCount);
    end;

    local procedure TestBulkPlayerImport()
    var
        TennisPlayer: Record "Tennis Player";
        PlayerCount: Integer;
        i: Integer;
    begin
        // [SCENARIO] Bulk import of multiple players

        LibraryTennisTest.CreateTennisSetup();

        // Import 50 players
        for i := 1 to 50 do
            LibraryTennisTest.CreateTennisPlayer(
                StrSubstNo('Bulk Player %1', i),
                CalcDate(StrSubstNo('-%1D', i), Today()),
                StrSubstNo('+1-555-%1', PadStr(Format(i), 4, '0')),
                StrSubstNo('player%1@bulk.test', i)
            );

        // Verify all players created
        PlayerCount := TennisPlayer.Count();
        if PlayerCount < 50 then
            Error('Should have at least 50 players, but found %1', PlayerCount);
    end;

    local procedure TestBulkMatchCreation()
    var
        TennisMatch: Record "Tennis Match";
        MatchCount: Integer;
        i: Integer;
        TestDate: Date;
    begin
        // [SCENARIO] Bulk creation of matches over multiple dates

        LibraryTennisTest.CreateTennisSetup();

        // Create matches for 30 days
        for i := 1 to 30 do begin
            TestDate := CalcDate('<+' + Format(i) + 'D>', Today());
            LibraryTennisTest.CreateTennisMatch(TestDate, "Tennis Match Type"::Singles);
            LibraryTennisTest.CreateTennisMatch(TestDate, "Tennis Match Type"::Doubles);
        end;

        // Verify all matches created
        MatchCount := TennisMatch.Count();
        if MatchCount < 60 then
            Error('Should have at least 60 matches, but found %1', MatchCount);
    end;

    local procedure TestDataExport()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
        ExportedPlayers, ExportedMatches, ExportedMatchLines : Integer;
    begin
        // [SCENARIO] Data export scenario

        LibraryTennisTest.CreateTennisSetup();

        // Create test data
        LibraryTennisTest.CreateTennisPlayer('Export Player 1', Today(), '', '');
        LibraryTennisTest.CreateTennisPlayer('Export Player 2', Today(), '', '');
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);

        // Count records for export
        ExportedPlayers := TennisPlayer.Count();
        ExportedMatches := TennisMatch.Count();
        ExportedMatchLines := TennisMatchLine.Count();

        // Verify data exists for export
        if ExportedPlayers = 0 then
            Error('No players available for export');
        if ExportedMatches = 0 then
            Error('No matches available for export');
        if ExportedMatchLines = 0 then
            Error('No match lines available for export');
    end;

    local procedure TestPlayerAPIScenarios()
    var
        TennisPlayer: Record "Tennis Player";
        APITestPlayer: Record "Tennis Player";
        PlayerNo: Code[20];
    begin
        // [SCENARIO] Player API integration scenarios

        LibraryTennisTest.CreateTennisSetup();

        // Test API-like operations
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('API Test Player', Today(), '+1-555-API1', 'api@test.com');
        PlayerNo := TennisPlayer."No.";

        // Test GET operation
        if not APITestPlayer.Get(PlayerNo) then
            Error('API GET operation failed for player %1', PlayerNo);

        // Test UPDATE operation
        APITestPlayer.Name := 'Updated API Player';
        APITestPlayer.Modify();

        // Verify update
        APITestPlayer.Get(PlayerNo);
        if APITestPlayer.Name <> 'Updated API Player' then
            Error('API UPDATE operation failed');

        // Test DELETE operation
        APITestPlayer.Delete();
        if APITestPlayer.Get(PlayerNo) then
            Error('API DELETE operation failed');
    end;

    local procedure TestMatchAPIScenarios()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        APITestMatch: Record "Tennis Match";
        MatchNo: Code[20];
    begin
        // [SCENARIO] Match API integration scenarios

        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('API Match Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('API Match Player 2', Today(), '', '');

        // Test API-like operations
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        MatchNo := TennisMatch."No.";

        // Add players via API-like operations
        LibraryTennisTest.CreateTennisMatchLine(MatchNo, 1, TennisPlayer1."No.", "Tennis Match Team"::A, false);
        LibraryTennisTest.CreateTennisMatchLine(MatchNo, 2, TennisPlayer2."No.", "Tennis Match Team"::B, false);

        // Test GET operation
        if not APITestMatch.Get(MatchNo) then
            Error('API GET operation failed for match %1', MatchNo);

        // Test UPDATE operation
        APITestMatch.Status := "Tennis Match Status"::Finished;
        APITestMatch.Modify();

        // Verify update
        APITestMatch.Get(MatchNo);
        if APITestMatch.Status <> "Tennis Match Status"::Finished then
            Error('API UPDATE operation failed');
    end;

    local procedure TestPlayerReports()
    var
        TennisPlayer: Record "Tennis Player";
        PlayerCount: Integer;
    begin
        // [SCENARIO] Player report generation

        LibraryTennisTest.CreateTennisSetup();

        // Create test data for reports
        LibraryTennisTest.CreateTennisPlayer('Report Player 1', Today(), '+1-555-0001', 'report1@test.com');
        LibraryTennisTest.CreateTennisPlayer('Report Player 2', Today(), '+1-555-0002', 'report2@test.com');
        LibraryTennisTest.CreateTennisPlayer('Report Player 3', Today(), '+1-555-0003', 'report3@test.com');

        // Verify data for report
        PlayerCount := TennisPlayer.Count();
        if PlayerCount < 3 then
            Error('Insufficient data for player report generation');

        // Test report filters
        TennisPlayer.SetFilter(Name, 'Report Player*');
        if TennisPlayer.Count() <> 3 then
            Error('Player report filter not working correctly');
    end;

    local procedure TestMatchReports()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        MatchCount: Integer;
    begin
        // [SCENARIO] Match report generation

        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Match Report Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Match Report Player 2', Today(), '', '');

        // Create matches for different dates
        LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatch(CalcDate('+1D', Today()), "Tennis Match Type"::Doubles);
        LibraryTennisTest.CreateTennisMatch(CalcDate('+2D', Today()), "Tennis Match Type"::Singles);

        // Verify data for report
        MatchCount := TennisMatch.Count();
        if MatchCount < 3 then
            Error('Insufficient data for match report generation');

        // Test date range filters
        TennisMatch.SetRange("Match Date", Today(), CalcDate('+2D', Today()));
        if TennisMatch.Count() <> 3 then
            Error('Match report date filter not working correctly');
    end;

    local procedure TestStatisticsReports()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
        SinglesCount, DoublesCount : Integer;
    begin
        // [SCENARIO] Statistics report generation

        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Stats Player', Today(), '', '');

        // Create different match types for statistics
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, true);

        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Doubles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);

        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, true);

        // Calculate statistics
        TennisMatch.SetRange("Match Type", "Tennis Match Type"::Singles);
        SinglesCount := TennisMatch.Count();

        TennisMatch.SetRange("Match Type", "Tennis Match Type"::Doubles);
        DoublesCount := TennisMatch.Count();

        if SinglesCount <> 2 then
            Error('Expected 2 singles matches, found %1', SinglesCount);
        if DoublesCount <> 1 then
            Error('Expected 1 doubles match, found %1', DoublesCount);
    end;

    local procedure VerifyMatchReadiness(MatchNo: Code[20])
    var
        TennisMatchLine: Record "Tennis Match Line";
        PlayerCount: Integer;
    begin
        // Verify match has players assigned
        TennisMatchLine.SetRange("Match No.", MatchNo);
        PlayerCount := TennisMatchLine.Count();

        if PlayerCount < 2 then
            Error('Match %1 is not ready - needs at least 2 players, has %2', MatchNo, PlayerCount);
    end;

    local procedure VerifyCompletedMatch(MatchNo: Code[20])
    var
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
        WinnerCount: Integer;
    begin
        // Verify match is properly completed
        TennisMatch.Get(MatchNo);
        if TennisMatch.Status <> "Tennis Match Status"::Finished then
            Error('Match %1 should be finished', MatchNo);

        TennisMatchLine.SetRange("Match No.", MatchNo);
        TennisMatchLine.SetRange(Winner, true);
        WinnerCount := TennisMatchLine.Count();

        if WinnerCount <> 1 then
            Error('Completed match %1 should have exactly 1 winner, has %2', MatchNo, WinnerCount);
    end;

    local procedure VerifyTournamentStructure(var TennisMatch: array[4] of Record "Tennis Match")
    var
        TennisMatchLine: Record "Tennis Match Line";
        i, PlayerCount : Integer;
    begin
        // Verify tournament has correct structure
        for i := 1 to 4 do begin
            TennisMatchLine.SetRange("Match No.", TennisMatch[i]."No.");
            PlayerCount := TennisMatchLine.Count();
            if PlayerCount <> 2 then
                Error('Tournament match %1 should have 2 players, has %2', i, PlayerCount);
        end;
    end;

    local procedure CalculatePlayerWins(PlayerNo: Code[20]): Integer
    var
        TennisMatchLine: Record "Tennis Match Line";
    begin
        TennisMatchLine.SetRange("Player No.", PlayerNo);
        TennisMatchLine.SetRange(Winner, true);
        exit(TennisMatchLine.Count());
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
    end;
}