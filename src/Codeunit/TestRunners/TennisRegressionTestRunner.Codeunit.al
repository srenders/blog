codeunit 61113 "Tennis Regression Test Runner"
{
    Subtype = TestRunner;

    // Regression test runner for Tennis Management - tests critical scenarios that should not break using TestRunner subtype

    trigger OnRun()
    begin
        // Execute regression test suite
        RunRegressionTestSuite();
    end;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";
        IsInitialized: Boolean;

    local procedure RunRegressionTestSuite()
    begin
        // [SCENARIO] Execute regression test suite for critical functionality
        Initialize();

        // Run critical regression tests
        RegressionTest_PlayerManagement();
        RegressionTest_MatchManagement();
        RegressionTest_SetupConfiguration();
        RegressionTest_DataIntegrity();
        RegressionTest_BusinessLogic();
    end;

    local procedure RegressionTest_PlayerManagement()
    begin
        // [SCENARIO] Test critical player management scenarios
        Initialize();

        // Test various player scenarios that should not break
        TestPlayerWithSpecialCharacters();
        TestPlayerWithMaximumFieldLengths();
        TestPlayerDuplicateNames();
        TestPlayerEmailValidation();
        TestPlayerPhoneNumberFormats();
    end;

    local procedure RegressionTest_MatchManagement()
    begin
        // [SCENARIO] Test critical match management scenarios
        Initialize();

        // Test various match scenarios
        TestMatchDateBoundaries();
        TestMatchStatusTransitions();
        TestMatchTypeValidation();
        TestMatchWithoutPlayers();
        TestMatchPlayerAssignments();
    end;

    local procedure RegressionTest_SetupConfiguration()
    begin
        // [SCENARIO] Test setup configuration scenarios
        Initialize();

        // Test setup scenarios
        TestSetupNumberSeriesValidation();
        TestSetupModification();
        TestSetupDeletion();
        TestMultipleSetupRecords();
    end;

    local procedure RegressionTest_DataIntegrity()
    begin
        // [SCENARIO] Test data integrity scenarios
        Initialize();

        // Test data integrity
        TestOrphanedMatchLines();
        TestReferentialIntegrity();
        TestCascadingDeletes();
        TestDataConsistency();
    end;

    local procedure RegressionTest_BusinessLogic()
    begin
        // [SCENARIO] Test business logic scenarios
        Initialize();

        // Test business logic
        TestMatchWinnerLogic();
        TestPlayerAvailability();
        TestMatchScheduling();
        TestScoreCalculation();
    end;

    local procedure TestPlayerWithSpecialCharacters()
    var
        TennisPlayer: Record "Tennis Player";
    begin
        // Test player creation with special characters
        LibraryTennisTest.CreateTennisSetup();

        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Test & Player (Ltd.)', Today(), '', '');
        if TennisPlayer.Name <> 'Test & Player (Ltd.)' then
            Error('Player name with special characters should be preserved');

        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Test-Player_123', Today(), '', '');
        if TennisPlayer.Name <> 'Test-Player_123' then
            Error('Player name with hyphens and underscores should be preserved');
    end;

    local procedure TestPlayerWithMaximumFieldLengths()
    var
        TennisPlayer: Record "Tennis Player";
        LongName: Text[100];
        LongEmail: Text[80];
        LongPhone: Text[30];
    begin
        // Test player creation with maximum field lengths
        LibraryTennisTest.CreateTennisSetup();

        LongName := CopyStr(PadStr('Very Long Player Name', 100, 'X'), 1, 100);
        LongEmail := CopyStr(PadStr('verylongemail', 70, 'x') + '@test.com', 1, 80);
        LongPhone := CopyStr(PadStr('+1-555-', 30, '0'), 1, 30);

        TennisPlayer := LibraryTennisTest.CreateTennisPlayer(LongName, Today(), LongPhone, LongEmail);
        if TennisPlayer.Name = '' then
            Error('Player should be created with maximum field lengths');
    end;

    local procedure TestPlayerDuplicateNames()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
    begin
        // Test that duplicate player names are handled gracefully
        LibraryTennisTest.CreateTennisSetup();

        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Duplicate Test Player', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Duplicate Test Player', Today(), '', '');

        // Both players should be created (duplicate names allowed)
        if TennisPlayer1."No." = TennisPlayer2."No." then
            Error('Players with duplicate names should have different numbers');
    end;

    local procedure TestPlayerEmailValidation()
    var
        TennisPlayer: Record "Tennis Player";
    begin
        // Test email validation scenarios
        LibraryTennisTest.CreateTennisSetup();

        // Valid email formats should work
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Email Test 1', Today(), '', 'test@example.com');
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Email Test 2', Today(), '', 'user.name+tag@domain.co.uk');

        // Invalid email formats should be handled gracefully
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Email Test 3', Today(), '', 'invalid-email');
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Email Test 4', Today(), '', '');
    end;

    local procedure TestPlayerPhoneNumberFormats()
    var
        TennisPlayer: Record "Tennis Player";
    begin
        // Test various phone number formats
        LibraryTennisTest.CreateTennisSetup();

        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Phone Test 1', Today(), '+1-555-123-4567', '');
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Phone Test 2', Today(), '(555) 123-4567', '');
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Phone Test 3', Today(), '555.123.4567', '');
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Phone Test 4', Today(), '5551234567', '');
    end;

    local procedure TestMatchDateBoundaries()
    var
        TennisMatch: Record "Tennis Match";
    begin
        // Test match creation with boundary dates
        LibraryTennisTest.CreateTennisSetup();

        // Past date
        TennisMatch := LibraryTennisTest.CreateTennisMatch(DMY2Date(1, 1, 2020), "Tennis Match Type"::Singles);

        // Future date
        TennisMatch := LibraryTennisTest.CreateTennisMatch(DMY2Date(31, 12, 2030), "Tennis Match Type"::Doubles);

        // Today
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
    end;

    local procedure TestMatchStatusTransitions()
    var
        TennisMatch: Record "Tennis Match";
    begin
        // Test all possible status transitions
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);

        // Open -> Finished
        TennisMatch.Status := "Tennis Match Status"::Open;
        TennisMatch.Modify();
        TennisMatch.Status := "Tennis Match Status"::Finished;
        TennisMatch.Modify();

        // Finished -> Cancelled (should be allowed for corrections)
        TennisMatch.Status := "Tennis Match Status"::Cancelled;
        TennisMatch.Modify();

        // Cancelled -> Open (should be allowed for reactivation)
        TennisMatch.Status := "Tennis Match Status"::Open;
        TennisMatch.Modify();
    end;

    local procedure TestMatchTypeValidation()
    var
        TennisMatch: Record "Tennis Match";
    begin
        // Test all match types
        LibraryTennisTest.CreateTennisSetup();

        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        if TennisMatch."Match Type" <> "Tennis Match Type"::Singles then
            Error('Singles match type should be preserved');

        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Doubles);
        if TennisMatch."Match Type" <> "Tennis Match Type"::Doubles then
            Error('Doubles match type should be preserved');
    end;

    local procedure TestMatchWithoutPlayers()
    var
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // Test that match can exist without players initially
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);

        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        if TennisMatchLine.Count() <> 0 then
            Error('New match should have no players initially');
    end;

    local procedure TestMatchPlayerAssignments()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // Test player assignments to matches
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Match Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Match Player 2', Today(), '', '');
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);

        // Add players to different teams
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer1."No.", "Tennis Match Team"::A, false);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 2, TennisPlayer2."No.", "Tennis Match Team"::B, true);

        // Verify assignments
        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        TennisMatchLine.SetRange("Player No.", TennisPlayer1."No.");
        TennisMatchLine.FindFirst();
        if TennisMatchLine.Team <> "Tennis Match Team"::A then
            Error('Player 1 should be assigned to Team A');

        TennisMatchLine.SetRange("Player No.", TennisPlayer2."No.");
        TennisMatchLine.FindFirst();
        if TennisMatchLine.Team <> "Tennis Match Team"::B then
            Error('Player 2 should be assigned to Team B');
    end;

    local procedure TestSetupNumberSeriesValidation()
    var
        TennisSetup: Record "Tennis Setup";
        NoSeries: Record "No. Series";
    begin
        // Test setup with valid number series
        TennisSetup := LibraryTennisTest.CreateTennisSetup();

        // Validate that number series exist and work
        if not NoSeries.Get(TennisSetup."Player Nos.") then
            Error('Player number series should be valid');

        if not NoSeries.Get(TennisSetup."Match Nos.") then
            Error('Match number series should be valid');
    end;

    local procedure TestSetupModification()
    var
        TennisSetup: Record "Tennis Setup";
        OriginalPlayerNos: Code[20];
    begin
        // Test setup modification
        TennisSetup := LibraryTennisTest.CreateTennisSetup();
        OriginalPlayerNos := TennisSetup."Player Nos.";

        // Modify setup
        TennisSetup."Player Nos." := 'MODIFIED';
        TennisSetup.Modify();

        // Verify modification
        TennisSetup.Get();
        if TennisSetup."Player Nos." <> 'MODIFIED' then
            Error('Setup modification should be preserved');

        // Restore original
        TennisSetup."Player Nos." := OriginalPlayerNos;
        TennisSetup.Modify();
    end;

    local procedure TestSetupDeletion()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        // Test setup deletion (should be allowed if no data exists)
        TennisSetup := LibraryTennisTest.CreateTennisSetup();

        // Delete all players and matches first
        DeleteAllTestData();

        // Then delete setup
        TennisSetup.Delete();
    end;

    local procedure TestMultipleSetupRecords()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        // Test that only one setup record should exist
        TennisSetup := LibraryTennisTest.CreateTennisSetup();

        // Try to create another setup record
        TennisSetup.Init();
        TennisSetup."Player Nos." := 'SECOND';
        TennisSetup."Match Nos." := 'SECOND';
        // This might fail or be prevented by design
        if TennisSetup.Insert() then begin
            // If allowed, verify behavior
            TennisSetup.SetRange("Player Nos.", 'SECOND');
            if TennisSetup.Count() <> 1 then
                Error('Second setup record should exist if allowed');
        end;
    end;

    local procedure TestOrphanedMatchLines()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // Test handling of orphaned match lines
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Orphan Test Player', Today(), '', '');
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);

        // Delete the player (should handle orphaned match line gracefully)
        TennisPlayer.Delete();

        // Match line should still reference the deleted player number
        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        TennisMatchLine.FindFirst();
        if TennisMatchLine."Player No." <> TennisPlayer."No." then
            Error('Match line should retain player reference even after player deletion');
    end;

    local procedure TestReferentialIntegrity()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // Test referential integrity between tables
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Integrity Test Player', Today(), '', '');
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);

        // Verify relationships
        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        TennisMatchLine.FindFirst();

        if not TennisMatch.Get(TennisMatchLine."Match No.") then
            Error('Match should exist for match line');

        // Note: Player might not exist if deleted, but reference should remain
    end;

    local procedure TestCascadingDeletes()
    var
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
        TennisPlayer: Record "Tennis Player";
    begin
        // Test cascading deletes
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Cascade Test Player', Today(), '', '');
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);

        // Delete match should cascade to match lines
        TennisMatch.Delete(true);

        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        if TennisMatchLine.Count() <> 0 then
            Error('Match lines should be deleted when match is deleted');
    end;

    local procedure TestDataConsistency()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
        WinnerCount: Integer;
    begin
        // Test data consistency rules
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Consistency Test Player', Today(), '', '');
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, true);

        // Verify only one winner per match
        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        TennisMatchLine.SetRange(Winner, true);
        WinnerCount := TennisMatchLine.Count();
        if WinnerCount > 1 then
            Error('Match should have at most one winner, but has %1', WinnerCount);
    end;

    local procedure TestMatchWinnerLogic()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // Test match winner logic
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Winner Test Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Winner Test Player 2', Today(), '', '');
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);

        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer1."No.", "Tennis Match Team"::A, true);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 2, TennisPlayer2."No.", "Tennis Match Team"::B, false);

        // Verify winner logic
        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        TennisMatchLine.SetRange(Winner, true);
        TennisMatchLine.FindFirst();
        if TennisMatchLine."Player No." <> TennisPlayer1."No." then
            Error('Player 1 should be marked as winner');
    end;

    local procedure TestPlayerAvailability()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch1, TennisMatch2 : Record "Tennis Match";
    begin
        // Test player availability logic (same player in multiple matches)
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Availability Test Player', Today(), '', '');
        TennisMatch1 := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        TennisMatch2 := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Doubles);

        // Player can be in multiple matches (business rule dependent)
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch1."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch2."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);
    end;

    local procedure TestMatchScheduling()
    var
        TennisMatch1, TennisMatch2 : Record "Tennis Match";
    begin
        // Test match scheduling logic
        LibraryTennisTest.CreateTennisSetup();

        // Multiple matches on same date should be allowed
        TennisMatch1 := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        TennisMatch2 := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Doubles);

        if TennisMatch1."Match Date" <> TennisMatch2."Match Date" then
            Error('Both matches should be scheduled for the same date');
    end;

    local procedure TestScoreCalculation()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
        TeamACount, TeamBCount, WinnerCount : Integer;
    begin
        // Test score calculation logic
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Score Test Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Score Test Player 2', Today(), '', '');
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);

        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer1."No.", "Tennis Match Team"::A, true);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 2, TennisPlayer2."No.", "Tennis Match Team"::B, false);

        // Count team members
        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        TennisMatchLine.SetRange(Team, "Tennis Match Team"::A);
        TeamACount := TennisMatchLine.Count();

        TennisMatchLine.SetRange(Team, "Tennis Match Team"::B);
        TeamBCount := TennisMatchLine.Count();

        TennisMatchLine.SetRange(Team);
        TennisMatchLine.SetRange(Winner, true);
        WinnerCount := TennisMatchLine.Count();

        if (TeamACount <> 1) or (TeamBCount <> 1) then
            Error('Singles match should have 1 player per team');

        if WinnerCount <> 1 then
            Error('Match should have exactly 1 winner');
    end;

    local procedure DeleteAllTestData()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // Clean up all test data
        TennisMatchLine.DeleteAll();
        TennisMatch.DeleteAll();
        TennisPlayer.DeleteAll();
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
    end;
}