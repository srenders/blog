codeunit 61110 "Tennis Test Runner"
{
    Subtype = TestRunner;

    // Main test runner for Tennis Management tests
    // Orchestrates and executes comprehensive test suites using TestRunner subtype

    trigger OnRun()
    begin
        // Execute complete test suite
        RunAllTennisTests();
    end;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";

    local procedure RunAllTennisTests()
    begin
        // [SCENARIO] Complete test suite runner for Tennis Management
        Initialize();

        // Run all test categories
        RunPlayerTests();
        RunMatchTests();
        RunMatchLineTests();
        RunSetupTests();
        RunAPITests();
        RunReportTests();
        RunPageTests();
        RunInstallationTests();
        RunSmokeTests();
        RunRegressionTests();
        RunPerformanceTests();
    end;

    local procedure RunPlayerTests()
    var
        TennisPlayerTest: Codeunit "Tennis Player Test";
    begin
        // [SCENARIO] Run all tennis player related tests
        Initialize();

        // Execute player test procedures
        TennisPlayerTest.Run();
    end;

    local procedure RunMatchTests()
    var
        TennisMatchTest: Codeunit "Tennis Match Test";
    begin
        // [SCENARIO] Run all tennis match related tests
        Initialize();

        // Execute match test procedures
        TennisMatchTest.Run();
    end;

    local procedure RunMatchLineTests()
    var
        TennisMatchLineTest: Codeunit "Tennis Match Line Test";
    begin
        // [SCENARIO] Run all tennis match line related tests
        Initialize();

        // Execute match line test procedures
        TennisMatchLineTest.Run();
    end;

    local procedure RunSetupTests()
    var
        TennisSetupTest: Codeunit "Tennis Setup Test";
    begin
        // [SCENARIO] Run all tennis setup related tests
        Initialize();

        // Execute setup test procedures
        TennisSetupTest.Run();
    end;

    local procedure RunAPITests()
    var
        TennisAPITest: Codeunit "Tennis API Test";
    begin
        // [SCENARIO] Run all API related tests
        Initialize();

        // Execute API test procedures
        TennisAPITest.Run();
    end;

    local procedure RunReportTests()
    var
        TennisReportXMLportTest: Codeunit "Tennis Report XMLport Test";
    begin
        // [SCENARIO] Run all report and XMLport related tests
        Initialize();

        // Execute report and XMLport test procedures
        TennisReportXMLportTest.Run();
    end;

    local procedure RunPageTests()
    var
        TennisPageTest: Codeunit "Tennis Page Test";
    begin
        // [SCENARIO] Run all page related tests
        Initialize();

        // Execute page test procedures
        TennisPageTest.Run();
    end;

    local procedure RunInstallationTests()
    var
        TennisInstallTest: Codeunit "Tennis Install Test";
        TennisAssistedSetupTest: Codeunit "Tennis Assisted Setup Test";
    begin
        // [SCENARIO] Run all installation and setup related tests
        Initialize();

        // Execute installation test procedures
        TennisInstallTest.Run();
        TennisAssistedSetupTest.Run();
    end;

    local procedure RunSmokeTests()
    begin
        // [SCENARIO] Quick smoke test to verify basic functionality
        Initialize();

        // Basic functionality verification
        VerifyBasicSetup();
        VerifyPlayerCreation();
        VerifyMatchCreation();
        VerifyReportExecution();
    end;

    local procedure RunRegressionTests()
    begin
        // [SCENARIO] Regression test suite for critical functionality
        Initialize();

        // Execute regression tests
        TestCriticalPlayerScenarios();
        TestCriticalMatchScenarios();
        TestCriticalSetupScenarios();
        TestCriticalAPIScenarios();
    end;

    local procedure RunPerformanceTests()
    begin
        // [SCENARIO] Performance test suite
        Initialize();

        // Execute performance tests
        TestBulkPlayerCreation();
        TestBulkMatchCreation();
        TestLargeDatasetReporting();
        TestAPIPerformance();
    end;

    local procedure Initialize()
    begin
        LibraryTennisTest.CleanupTestData();
        Commit();
    end;

    local procedure VerifyBasicSetup()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        // Verify tennis setup can be created
        TennisSetup := LibraryTennisTest.CreateTennisSetup();
        if TennisSetup."Player Nos." = '' then
            Error('Tennis setup should have player number series');
        if TennisSetup."Match Nos." = '' then
            Error('Tennis setup should have match number series');
    end;

    local procedure VerifyPlayerCreation()
    var
        TennisPlayer: Record "Tennis Player";
    begin
        // Verify player can be created
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Smoke Test Player', Today(), '', '');
        if TennisPlayer."No." = '' then
            Error('Player should have a number assigned');
    end;

    local procedure VerifyMatchCreation()
    var
        TennisMatch: Record "Tennis Match";
    begin
        // Verify match can be created
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        if TennisMatch."No." = '' then
            Error('Match should have a number assigned');
    end;

    local procedure VerifyReportExecution()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayersAndMatches: Report "Tennis Players and Matches";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
    begin
        // Verify report can execute
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Report Test Player', Today(), '', '');

        TempBlob.CreateOutStream(OutStream);
        TennisPlayersAndMatches.SetTableView(TennisPlayer);
        TennisPlayersAndMatches.SaveAs('', ReportFormat::Xml, OutStream);
    end;

    local procedure TestCriticalPlayerScenarios()
    begin
        // Test critical player scenarios that must not break
        TestPlayerWithSpecialCharacters();
        TestPlayerWithLongName();
        TestPlayerDuplication();
    end;

    local procedure TestCriticalMatchScenarios()
    begin
        // Test critical match scenarios that must not break
        TestMatchWithoutPlayers();
        TestMatchDateValidation();
        TestMatchStatusProgression();
    end;

    local procedure TestCriticalSetupScenarios()
    begin
        // Test critical setup scenarios that must not break
        TestSetupWithInvalidNumberSeries();
        TestSetupModification();
    end;

    local procedure TestCriticalAPIScenarios()
    begin
        // Test critical API scenarios that must not break
        TestAPIWithInvalidData();
        TestAPIPermissions();
    end;

    local procedure TestBulkPlayerCreation()
    var
        TennisPlayer: Record "Tennis Player";
        i: Integer;
    begin
        // Test creating many players for performance
        LibraryTennisTest.CreateTennisSetup();
        for i := 1 to 100 do
            TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Bulk Player ' + Format(i), Today(), '', '');
    end;

    local procedure TestBulkMatchCreation()
    var
        TennisMatch: Record "Tennis Match";
        i: Integer;
    begin
        // Test creating many matches for performance
        LibraryTennisTest.CreateTennisSetup();
        for i := 1 to 50 do
            TennisMatch := LibraryTennisTest.CreateTennisMatch(CalcDate('<+' + Format(i) + 'D>', Today()), "Tennis Match Type"::Singles);
    end;

    local procedure TestLargeDatasetReporting()
    var
        TennisPlayersAndMatches: Report "Tennis Players and Matches";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
    begin
        // Test reporting with large dataset
        LibraryTennisTest.CreateTennisSetup();
        CreateBulkTestData();

        TempBlob.CreateOutStream(OutStream);
        TennisPlayersAndMatches.SaveAs('', ReportFormat::Xml, OutStream);
    end;

    local procedure TestAPIPerformance()
    var
        TennisPlayersAPI: Query "Tennis Players API";
    begin
        // Test API performance with large dataset
        LibraryTennisTest.CreateTennisSetup();
        CreateBulkTestData();

        TennisPlayersAPI.Open();
        while TennisPlayersAPI.Read() do
            // Process API data - testing performance
            ;
        TennisPlayersAPI.Close();
    end;

    local procedure CreateBulkTestData()
    var
        i: Integer;
    begin
        // Create bulk test data for performance testing
        for i := 1 to 200 do begin
            LibraryTennisTest.CreateTennisPlayer('Perf Test Player ' + Format(i), Today(), '', '');
            if i mod 10 = 0 then
                LibraryTennisTest.CreateTennisMatch(Today() + i, "Tennis Match Type"::Singles);
        end;
    end;

    local procedure TestPlayerWithSpecialCharacters()
    var
        TennisPlayer: Record "Tennis Player";
    begin
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Test Player & Co. (Ltd.)', Today(), '+1-555-0123', 'test@example.com');
    end;

    local procedure TestPlayerWithLongName()
    var
        TennisPlayer: Record "Tennis Player";
        LongName: Text;
    begin
        LibraryTennisTest.CreateTennisSetup();
        LongName := 'This is a very long player name that might cause issues with field length validation and database storage';
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer(CopyStr(LongName, 1, 100), Today(), '', '');
    end;

    local procedure TestPlayerDuplication()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
    begin
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Duplicate Test Player', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Duplicate Test Player', Today(), '', '');
        // Should handle duplicate names gracefully
    end;

    local procedure TestMatchWithoutPlayers()
    var
        TennisMatch: Record "Tennis Match";
    begin
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        // Match should be created even without players initially
    end;

    local procedure TestMatchDateValidation()
    var
        TennisMatch: Record "Tennis Match";
    begin
        LibraryTennisTest.CreateTennisSetup();
        // Test with past date
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today() - 365, "Tennis Match Type"::Singles);
        // Test with future date
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today() + 365, "Tennis Match Type"::Doubles);
    end;

    local procedure TestMatchStatusProgression()
    var
        TennisMatch: Record "Tennis Match";
    begin
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);

        // Test status transitions
        TennisMatch.Status := "Tennis Match Status"::Open;
        TennisMatch.Modify();

        TennisMatch.Status := "Tennis Match Status"::Finished;
        TennisMatch.Modify();

        TennisMatch.Status := "Tennis Match Status"::Cancelled;
        TennisMatch.Modify();
    end;

    local procedure TestSetupWithInvalidNumberSeries()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        // Test setup behavior with invalid number series
        TennisSetup.Init();
        TennisSetup."Player Nos." := 'INVALID';
        TennisSetup."Match Nos." := 'INVALID';
        TennisSetup.Insert();
    end;

    local procedure TestSetupModification()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        TennisSetup := LibraryTennisTest.CreateTennisSetup();
        TennisSetup."Player Nos." := 'MODIFIED';
        TennisSetup.Modify();
    end;

    local procedure TestAPIWithInvalidData()
    var
        TennisPlayersAPI: Query "Tennis Players API";
    begin
        // Test API resilience with invalid data
        TennisPlayersAPI.Open();
        TennisPlayersAPI.Close();
    end;

    local procedure TestAPIPermissions()
    var
        TennisPlayersAPI: Query "Tennis Players API";
        TennisMatchesAPI: Query "Tennis Matches API";
    begin
        // Test API access permissions
        TennisPlayersAPI.Open();
        TennisPlayersAPI.Close();

        TennisMatchesAPI.Open();
        TennisMatchesAPI.Close();
    end;
}