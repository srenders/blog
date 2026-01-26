codeunit 61109 "Tennis Report XMLport Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";
        TempBlob: Codeunit "Temp Blob";

    [Test]
    procedure TestTennisPlayersAndMatchesReport()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
        TennisPlayersAndMatches: Report "Tennis Players and Matches";
        OutStream: OutStream;
        InStream: InStream;
    begin
        // [SCENARIO] Tennis Players and Matches report generates correctly
        Initialize();

        // [GIVEN] Tennis Management setup with player and matches
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Report Test Player', Today(), '+1234567890', 'report@test.com');

        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, true);

        // [WHEN] Running the report
        TempBlob.CreateOutStream(OutStream);
        TennisPlayersAndMatches.SetTableView(TennisPlayer);
        TennisPlayersAndMatches.SaveAs('', ReportFormat::Xml, OutStream);

        // [THEN] Report should generate without error and contain data
        TempBlob.CreateInStream(InStream);
        if InStream.Length = 0 then
            Error('Report should generate content');
    end;

    [Test]
    procedure TestTennisPlayersAndMatchesReportFiltering()
    var
        TennisPlayer1, TennisPlayer2 : Record "Tennis Player";
        TennisPlayersAndMatches: Report "Tennis Players and Matches";
        OutStream: OutStream;
        InStream: InStream;
        ReportContent: Text;
    begin
        // [SCENARIO] Tennis Players and Matches report filters correctly
        Initialize();

        // [GIVEN] Tennis Management setup with multiple players
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer1 := LibraryTennisTest.CreateTennisPlayer('Filter Test Player 1', Today(), '', '');
        TennisPlayer2 := LibraryTennisTest.CreateTennisPlayer('Filter Test Player 2', Today(), '', '');

        // [WHEN] Running the report with filter for specific player
        TempBlob.CreateOutStream(OutStream);
        TennisPlayer1.SetRange("No.", TennisPlayer1."No.");
        TennisPlayersAndMatches.SetTableView(TennisPlayer1);
        TennisPlayersAndMatches.SaveAs('', ReportFormat::Xml, OutStream);

        // [THEN] Report should contain only filtered player
        TempBlob.CreateInStream(InStream);
        InStream.Read(ReportContent);
        if StrPos(ReportContent, TennisPlayer2."No.") > 0 then
            Error('Report should not contain filtered out player');
    end;

    [Test]
    procedure TestTennisPlayerXMLPortExport()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayerXMLPort: XMLport "Tennis Player";
        OutStream: OutStream;
        InStream: InStream;
        ExportContent: Text;
    begin
        // [SCENARIO] Tennis Player XMLport can export player data
        Initialize();

        // [GIVEN] Tennis Management setup and a player
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('XML Export Player', Today(), '+1234567890', 'xml@test.com');

        // [WHEN] Exporting player via XMLport
        TempBlob.CreateOutStream(OutStream);
        TennisPlayer.SetRange("No.", TennisPlayer."No.");
        TennisPlayerXMLPort.SetTableView(TennisPlayer);
        TennisPlayerXMLPort.SetDestination(OutStream);
        TennisPlayerXMLPort.Export();

        // [THEN] Export should contain player data
        TempBlob.CreateInStream(InStream);
        InStream.Read(ExportContent);
        if StrPos(ExportContent, TennisPlayer."No.") = 0 then
            Error('Export should contain player number');
        if StrPos(ExportContent, TennisPlayer.Name) = 0 then
            Error('Export should contain player name');
    end;

    [Test]
    procedure TestTennisPlayerXMLPortImport()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayerXMLPort: XMLport "Tennis Player";
        OutStream: OutStream;
        InStream: InStream;
        ImportXML: Text;
        NewPlayerNo: Code[20];
    begin
        // [SCENARIO] Tennis Player XMLport can import player data
        Initialize();

        // [GIVEN] Tennis Management setup and XML content
        LibraryTennisTest.CreateTennisSetup();
        NewPlayerNo := 'XMLIMPORT001';

        // Create XML content for import
        ImportXML := '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' +
                    '<RootNodeName>' +
                    '<TennisPlayer>' +
                    '<Number>' + NewPlayerNo + '</Number>' +
                    '<Name>XML Import Player</Name>' +
                    '<DateOfBirth>2024-01-01</DateOfBirth>' +
                    '<PhoneNo>+9876543210</PhoneNo>' +
                    '<Email>xmlimport@test.com</Email>' +
                    '</TennisPlayer>' +
                    '</RootNodeName>';

        // [WHEN] Importing player via XMLport
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(ImportXML);
        TempBlob.CreateInStream(InStream);

        TennisPlayerXMLPort.SetSource(InStream);
        TennisPlayerXMLPort.Import();

        // [THEN] Player should be created from import
        if not TennisPlayer.Get(NewPlayerNo) then
            Error('Imported player should exist');

        if TennisPlayer.Name <> 'XML Import Player' then
            Error('Imported player name should match XML content');

        if TennisPlayer."E-Mail" <> 'xmlimport@test.com' then
            Error('Imported player email should match XML content');
    end;

    [Test]
    procedure TestTennisPlayerXMLPortSkipExisting()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayerXMLPort: XMLport "Tennis Player";
        OutStream: OutStream;
        InStream: InStream;
        ImportXML: Text;
        ExistingPlayerNo: Code[20];
        PlayerCount: Integer;
    begin
        // [SCENARIO] Tennis Player XMLport skips existing players during import
        Initialize();

        // [GIVEN] Tennis Management setup and an existing player
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Existing Player', Today(), '', '');
        ExistingPlayerNo := TennisPlayer."No.";
        PlayerCount := TennisPlayer.Count();

        // Create XML content with existing player number
        ImportXML := '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' +
                    '<RootNodeName>' +
                    '<TennisPlayer>' +
                    '<Number>' + ExistingPlayerNo + '</Number>' +
                    '<Name>Updated Player Name</Name>' +
                    '<DateOfBirth>2024-01-01</DateOfBirth>' +
                    '<PhoneNo></PhoneNo>' +
                    '<Email></Email>' +
                    '</TennisPlayer>' +
                    '</RootNodeName>';

        // [WHEN] Importing with existing player number
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(ImportXML);
        TempBlob.CreateInStream(InStream);

        TennisPlayerXMLPort.SetSource(InStream);
        TennisPlayerXMLPort.Import();

        // [THEN] Existing player should not be changed and count should remain same
        if TennisPlayer.Count() <> PlayerCount then
            Error('Player count should remain the same');

        TennisPlayer.Get(ExistingPlayerNo);
        if TennisPlayer.Name = 'Updated Player Name' then
            Error('Existing player should not be updated');
    end;

    local procedure Initialize()
    begin
        LibraryTennisTest.CleanupTestData();
        Commit();
    end;
}