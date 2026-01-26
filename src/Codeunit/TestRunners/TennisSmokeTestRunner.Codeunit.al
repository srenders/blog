codeunit 61111 "Tennis Smoke Test Runner"
{
    Subtype = TestRunner;

    // Smoke test runner for Tennis Management - quick validation of core functionality using TestRunner subtype

    trigger OnRun()
    begin
        // Execute smoke test suite
        RunSmokeTestSuite();
    end;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";


    local procedure RunSmokeTestSuite()
    begin
        // [SCENARIO] Execute smoke test suite to verify basic Tennis Management functionality
        Initialize();

        // Run critical smoke tests
        SmokeTest_Setup();
        SmokeTest_PlayerCreation();
        SmokeTest_MatchCreation();
        SmokeTest_BasicReporting();
        SmokeTest_APIAccess();
        SmokeTest_MatchWithPlayers();
        SmokeTest_XMLPortExport();
    end;

    local procedure SmokeTest_Setup()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        // [SCENARIO] Verify tennis setup can be created and configured
        Initialize();

        // [WHEN] Creating tennis setup
        TennisSetup := LibraryTennisTest.CreateTennisSetup();

        // [THEN] Setup should have required fields
        if TennisSetup."Player Nos." = '' then
            Error('Tennis setup must have player number series configured');
        if TennisSetup."Match Nos." = '' then
            Error('Tennis setup must have match number series configured');
    end;

    local procedure SmokeTest_PlayerCreation()
    var
        TennisPlayer: Record "Tennis Player";
        PlayerNo: Code[20];
    begin
        // [SCENARIO] Verify tennis player can be created with automatic numbering
        Initialize();

        // [GIVEN] Tennis setup exists
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Creating a tennis player
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Smoke Test Player', Today(), '+1-555-0123', 'smoke@test.com');
        PlayerNo := TennisPlayer."No.";

        // [THEN] Player should be created with valid data
        if PlayerNo = '' then
            Error('Player number should be automatically assigned');
        TennisPlayer.Get(PlayerNo);
        if TennisPlayer.Name <> 'Smoke Test Player' then
            Error('Player name should be saved correctly');
        if TennisPlayer."Phone No." <> '+1-555-0123' then
            Error('Player phone number should be saved correctly');
    end;

    local procedure SmokeTest_MatchCreation()
    var
        TennisMatch: Record "Tennis Match";
        MatchNo: Code[20];
    begin
        // [SCENARIO] Verify tennis match can be created with automatic numbering
        Initialize();

        // [GIVEN] Tennis setup exists
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Creating a tennis match
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        MatchNo := TennisMatch."No.";

        // [THEN] Match should be created with valid data
        if MatchNo = '' then
            Error('Match number should be automatically assigned');
        TennisMatch.Get(MatchNo);
        if TennisMatch."Match Date" <> Today() then
            Error('Match date should be saved correctly');
        if TennisMatch."Match Type" <> "Tennis Match Type"::Singles then
            Error('Match type should be saved correctly');
    end;

    local procedure SmokeTest_BasicReporting()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayersAndMatches: Report "Tennis Players and Matches";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
    begin
        // [SCENARIO] Verify basic reporting functionality works
        Initialize();

        // [GIVEN] Tennis setup and test data
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Report Test Player', Today(), '', '');

        // [WHEN] Running the Tennis Players and Matches report
        TempBlob.CreateOutStream(OutStream);
        TennisPlayersAndMatches.SetTableView(TennisPlayer);
        TennisPlayersAndMatches.SaveAs('', ReportFormat::Xml, OutStream);

        // [THEN] Report should generate content
        TempBlob.CreateInStream(InStream);
        if InStream.Length = 0 then
            Error('Report should generate XML content');
    end;

    local procedure SmokeTest_APIAccess()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayersAPI: Query "Tennis Players API";
        RecordFound: Boolean;
    begin
        // [SCENARIO] Verify API queries can access data
        Initialize();

        // [GIVEN] Tennis setup and test player
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('API Test Player', Today(), '', '');

        // [WHEN] Accessing data through API query
        TennisPlayersAPI.Open();
        RecordFound := false;
        while TennisPlayersAPI.Read() do
            if TennisPlayersAPI.PlayerNo = TennisPlayer."No." then
                RecordFound := true;
        TennisPlayersAPI.Close();

        // [THEN] Player should be accessible through API
        if not RecordFound then
            Error('Player should be accessible through Tennis Players API');
    end;

    local procedure SmokeTest_MatchWithPlayers()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisMatchLine: Record "Tennis Match Line";
    begin
        // [SCENARIO] Verify complete match with players can be created
        Initialize();

        // [GIVEN] Tennis setup and players
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Player 2', Today(), '', '');

        // [WHEN] Creating match with players
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer1."No.", "Tennis Match Team"::A, false);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 2, TennisPlayer2."No.", "Tennis Match Team"::B, true);

        // [THEN] Match lines should be created correctly
        TennisMatchLine.SetRange("Match No.", TennisMatch."No.");
        if TennisMatchLine.Count <> 2 then
            Error('Match should have exactly 2 players');

        TennisMatchLine.SetRange(Winner, true);
        if TennisMatchLine.Count <> 1 then
            Error('Match should have exactly 1 winner');
    end;

    local procedure SmokeTest_XMLPortExport()
    var
        TennisPlayer: Record "Tennis Player";
        TempBlob: Codeunit "Temp Blob";
        TennisPlayerXMLPort: XMLport "Tennis Player";
        OutStream: OutStream;
        InStream: InStream;
        ExportContent: Text;
    begin
        // [SCENARIO] Verify XMLport export functionality
        Initialize();

        // [GIVEN] Tennis setup and test player
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('XML Export Player', Today(), '', '');

        // [WHEN] Exporting player via XMLport
        TempBlob.CreateOutStream(OutStream);
        TennisPlayer.SetRange("No.", TennisPlayer."No.");
        TennisPlayerXMLPort.SetTableView(TennisPlayer);
        TennisPlayerXMLPort.SetDestination(OutStream);
        TennisPlayerXMLPort.Export();

        // [THEN] Export should contain player data
        TempBlob.CreateInStream(InStream);
        InStream.ReadText(ExportContent);
        if StrPos(ExportContent, TennisPlayer."No.") = 0 then
            Error('Export should contain player number');
        if StrPos(ExportContent, TennisPlayer.Name) = 0 then
            Error('Export should contain player name');
    end;

    local procedure Initialize()
    begin
        LibraryTennisTest.CleanupTestData();
        Commit();
    end;
}