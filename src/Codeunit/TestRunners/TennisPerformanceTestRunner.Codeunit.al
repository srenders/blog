codeunit 61112 "Tennis Performance Test Runner"
{
    Subtype = TestRunner;

    // Performance test runner for Tennis Management - tests system performance with larger datasets using TestRunner subtype

    trigger OnRun()
    begin
        // Execute performance test suite
        RunPerformanceTestSuite();
    end;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";

    local procedure RunPerformanceTestSuite()
    begin
        // [SCENARIO] Execute performance test suite
        Initialize();

        // Run performance tests
        PerformanceTest_BulkPlayerCreation();
        PerformanceTest_BulkMatchCreation();
        PerformanceTest_LargeDatasetReporting();
        PerformanceTest_MassDataDeletion();
        PerformanceTest_ComplexMatchScenarios();
        PerformanceTest_ConcurrentDataAccess();
    end;

    local procedure PerformanceTest_BulkPlayerCreation()
    var
        TennisPlayer: Record "Tennis Player";
        i: Integer;
        StartTime: DateTime;
        EndTime: DateTime;
        ElapsedTime: Duration;
        PlayerCount: Integer;
    begin
        // [SCENARIO] Test performance of creating multiple players
        Initialize();

        // [GIVEN] Tennis setup
        LibraryTennisTest.CreateTennisSetup();
        StartTime := CurrentDateTime();

        // [WHEN] Creating 100 players
        for i := 1 to 100 do
            TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Perf Player ' + Format(i), Today(), '', '');

        EndTime := CurrentDateTime();
        ElapsedTime := EndTime - StartTime;

        // [THEN] Verify all players were created and performance is acceptable
        TennisPlayer.SetFilter(Name, 'Perf Player*');
        PlayerCount := TennisPlayer.Count();
        if PlayerCount <> 100 then
            Error('Should have created exactly 100 players, but created %1', PlayerCount);

        // Performance check - should complete within reasonable time (5 seconds)
        if ElapsedTime > 5000 then
            Error('Bulk player creation took too long: %1 ms', ElapsedTime);
    end;

    local procedure PerformanceTest_BulkMatchCreation()
    var
        TennisMatch: Record "Tennis Match";
        i: Integer;
        StartTime: DateTime;
        EndTime: DateTime;
        ElapsedTime: Duration;
        MatchCount: Integer;
    begin
        // [SCENARIO] Test performance of creating multiple matches
        Initialize();

        // [GIVEN] Tennis setup
        LibraryTennisTest.CreateTennisSetup();
        StartTime := CurrentDateTime();

        // [WHEN] Creating 50 matches
        for i := 1 to 50 do
            TennisMatch := LibraryTennisTest.CreateTennisMatch(Today() + i, "Tennis Match Type"::Singles);

        EndTime := CurrentDateTime();
        ElapsedTime := EndTime - StartTime;

        // [THEN] Verify all matches were created and performance is acceptable
        TennisMatch.SetRange("Match Date", Today() + 1, Today() + 50);
        MatchCount := TennisMatch.Count();
        if MatchCount <> 50 then
            Error('Should have created exactly 50 matches, but created %1', MatchCount);

        // Performance check
        if ElapsedTime > 3000 then
            Error('Bulk match creation took too long: %1 ms', ElapsedTime);
    end;

    local procedure PerformanceTest_LargeDatasetReporting()
    var
        TennisPlayersAndMatches: Report "Tennis Players and Matches";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        StartTime: DateTime;
        EndTime: DateTime;
        ElapsedTime: Duration;
        ReportSize: BigInteger;
    begin
        // [SCENARIO] Test performance of reporting with large dataset
        Initialize();

        // [GIVEN] Tennis setup and large dataset
        LibraryTennisTest.CreateTennisSetup();
        CreateLargeTestDataset();

        StartTime := CurrentDateTime();

        // [WHEN] Running report on large dataset
        TempBlob.CreateOutStream(OutStream);
        TennisPlayersAndMatches.SaveAs('', ReportFormat::Xml, OutStream);

        EndTime := CurrentDateTime();
        ElapsedTime := EndTime - StartTime;

        // [THEN] Report should complete within reasonable time and generate content
        TempBlob.CreateInStream(InStream);
        ReportSize := InStream.Length();

        if ReportSize = 0 then
            Error('Report should generate content with large dataset');

        // Performance check - should complete within 10 seconds
        if ElapsedTime > 10000 then
            Error('Large dataset reporting took too long: %1 ms', ElapsedTime);
    end;

    local procedure PerformanceTest_MassDataDeletion()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        StartTime: DateTime;
        EndTime: DateTime;
        ElapsedTime: Duration;
    begin
        // [SCENARIO] Test performance of deleting large amounts of data
        Initialize();

        // [GIVEN] Tennis setup and test data
        LibraryTennisTest.CreateTennisSetup();
        CreateMediumTestDataset();

        TennisPlayer.SetFilter(Name, 'Mass Test*');
        TennisMatch.SetFilter("Match Date", '%1..', Today());

        StartTime := CurrentDateTime();

        // [WHEN] Deleting test data
        TennisPlayer.SetFilter(Name, 'Mass Test*');
        TennisPlayer.DeleteAll();

        TennisMatch.SetFilter("Match Date", '%1..', Today());
        TennisMatch.DeleteAll();

        EndTime := CurrentDateTime();
        ElapsedTime := EndTime - StartTime;

        // [THEN] Data should be deleted and performance should be acceptable
        TennisPlayer.SetFilter(Name, 'Mass Test*');
        if TennisPlayer.Count() <> 0 then
            Error('All test players should be deleted');

        TennisMatch.SetFilter("Match Date", '%1..', Today());
        if TennisMatch.Count() <> 0 then
            Error('All test matches should be deleted');

        // Performance check
        if ElapsedTime > 5000 then
            Error('Mass data deletion took too long: %1 ms', ElapsedTime);
    end;

    local procedure PerformanceTest_ComplexMatchScenarios()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
        i, j : Integer;
        StartTime: DateTime;
        EndTime: DateTime;
        ElapsedTime: Duration;
        TotalMatchLines: Integer;
    begin
        // [SCENARIO] Test performance of creating matches with players (complex scenarios)
        Initialize();

        // [GIVEN] Tennis setup and players
        LibraryTennisTest.CreateTennisSetup();
        for i := 1 to 20 do
            TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Complex Player ' + Format(i), Today(), '', '');

        StartTime := CurrentDateTime();

        // [WHEN] Creating 10 matches each with 2 players
        TennisPlayer.SetFilter(Name, 'Complex Player*');
        for i := 1 to 10 do begin
            TennisMatch := LibraryTennisTest.CreateTennisMatch(Today() + i, "Tennis Match Type"::Singles);

            // Add 2 random players to each match
            TennisPlayer.FindSet();
            j := 1;
            repeat
                if j <= 2 then begin
                    if j = 1 then
                        LibraryTennisTest.CreateTennisMatchLine(
                            TennisMatch."No.",
                            j,
                            TennisPlayer."No.",
                            "Tennis Match Team"::A,
                            true
                        )
                    else
                        LibraryTennisTest.CreateTennisMatchLine(
                            TennisMatch."No.",
                            j,
                            TennisPlayer."No.",
                            "Tennis Match Team"::B,
                            false
                        );
                    j += 1;
                end;
            until (TennisPlayer.Next() = 0) or (j > 2);
        end;

        EndTime := CurrentDateTime();
        ElapsedTime := EndTime - StartTime;

        // [THEN] All data should be created correctly and performance should be acceptable
        TennisMatch.SetRange("Match Date", Today() + 1, Today() + 10);
        if TennisMatch.Count() <> 10 then
            Error('Should have created 10 matches');

        TennisMatchLine.SetFilter("Match No.", TennisMatch.GetFilter("No."));
        TotalMatchLines := TennisMatchLine.Count();
        if TotalMatchLines <> 20 then
            Error('Should have created 20 match lines (2 per match), but created %1', TotalMatchLines);

        // Performance check
        if ElapsedTime > 8000 then
            Error('Complex match scenarios took too long: %1 ms', ElapsedTime);
    end;

    local procedure PerformanceTest_ConcurrentDataAccess()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisPlayersAPI: Query "Tennis Players API";
        StartTime: DateTime;
        EndTime: DateTime;
        ElapsedTime: Duration;
        APIRecordCount: Integer;
    begin
        // [SCENARIO] Test performance when accessing data through multiple channels
        Initialize();

        // [GIVEN] Tennis setup and test data
        LibraryTennisTest.CreateTennisSetup();
        CreateMediumTestDataset();

        StartTime := CurrentDateTime();

        // [WHEN] Accessing data through multiple methods concurrently
        // Direct table access
        TennisPlayer.SetFilter(Name, 'Concurrent*');
        TennisPlayer.FindSet();
        repeat
        // Process each player record
        until TennisPlayer.Next() = 0;

        // API access
        TennisPlayersAPI.Open();
        while TennisPlayersAPI.Read() do
            APIRecordCount += 1;
        TennisPlayersAPI.Close();

        // Match data access
        TennisMatch.FindSet();
        repeat
        // Process each match record
        until TennisMatch.Next() = 0;

        EndTime := CurrentDateTime();
        ElapsedTime := EndTime - StartTime;

        // [THEN] All data access should complete within reasonable time
        if APIRecordCount = 0 then
            Error('API should return records');

        // Performance check
        if ElapsedTime > 6000 then
            Error('Concurrent data access took too long: %1 ms', ElapsedTime);
    end;

    local procedure Initialize()
    begin
        LibraryTennisTest.CleanupTestData();
        Commit();
    end;

    local procedure CreateLargeTestDataset()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        i: Integer;
    begin
        // Create large dataset for performance testing
        for i := 1 to 200 do begin
            TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Large Dataset Player ' + Format(i), Today(), '', '');
            if i mod 5 = 0 then
                TennisMatch := LibraryTennisTest.CreateTennisMatch(Today() + (i div 5), "Tennis Match Type"::Singles);
        end;
    end;

    local procedure CreateMediumTestDataset()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        i: Integer;
    begin
        // Create medium dataset for performance testing
        for i := 1 to 50 do begin
            TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Mass Test Player ' + Format(i), Today(), '', '');
            TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Concurrent Player ' + Format(i), Today(), '', '');
            if i mod 3 = 0 then
                TennisMatch := LibraryTennisTest.CreateTennisMatch(Today() + (i div 3), "Tennis Match Type"::Doubles);
        end;
    end;
}