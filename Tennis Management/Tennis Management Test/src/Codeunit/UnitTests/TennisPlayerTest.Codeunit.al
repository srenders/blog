codeunit 61100 "Tennis Player Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";

    [Test]
    procedure TestTennisPlayerCreation()
    var
        TennisPlayer: Record "Tennis Player";
        PlayerNo: Code[20];
    begin
        // [SCENARIO] A tennis player can be created with automatic numbering
        Initialize();

        // [GIVEN] Tennis Management setup is configured
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Creating a new tennis player
        TennisPlayer.Init();
        TennisPlayer.Insert(true);
        PlayerNo := TennisPlayer."No.";

        // [THEN] Player should be created with auto-generated number
        if PlayerNo = '' then
            Error('Player number should not be empty');
        TennisPlayer.Get(PlayerNo);
        if TennisPlayer."No. Series" = '' then
            Error('No. Series should be populated');
    end;

    [Test]
    procedure TestTennisPlayerValidation()
    var
        TennisPlayer: Record "Tennis Player";
        PlayerName: Text[100];
        PhoneNo: Text[30];
        Email: Text[80];
    begin
        // [SCENARIO] Tennis player fields are validated correctly
        Initialize();

        // [GIVEN] Tennis Management setup is configured
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Creating a tennis player with valid data
        PlayerName := 'Test Player Name';
        PhoneNo := '+1234567890';
        Email := 'test@example.com';

        TennisPlayer := LibraryTennisTest.CreateTennisPlayer(PlayerName, Today(), PhoneNo, Email);

        // [THEN] Player should be created successfully with correct data
        if TennisPlayer.Name <> PlayerName then
            Error('Player name should match');
        if TennisPlayer."Phone No." <> PhoneNo then
            Error('Phone number should match');
        if TennisPlayer."E-Mail" <> Email then
            Error('Email should match');
        if TennisPlayer."Date of Birth" <> Today() then
            Error('Date of birth should match');
    end;

    [Test]
    procedure TestTennisPlayerNumberValidation()
    var
        TennisPlayer: Record "Tennis Player";
        CustomPlayerNo: Code[20];
    begin
        // [SCENARIO] Tennis player number validation works correctly
        Initialize();

        // [GIVEN] Tennis Management setup is configured
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Setting a custom player number
        CustomPlayerNo := 'PLAYER001';
        TennisPlayer.Init();
        TennisPlayer."No." := CustomPlayerNo;
        TennisPlayer.Insert(true);

        // [THEN] Player should be created with the custom number
        if TennisPlayer."No." <> CustomPlayerNo then
            Error('Player number should match custom value');
        if TennisPlayer."No. Series" <> '' then
            Error('No. Series should be empty for manual numbers');
    end;

    [Test]
    procedure TestTennisPlayerFlowFields()
    var
        TennisPlayer: Record "Tennis Player";
        TennisMatch: Record "Tennis Match";
    begin
        // [SCENARIO] Tennis player flow fields calculate correctly
        Initialize();

        // [GIVEN] Tennis Management setup and a player
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Test Player', Today(), '', '');

        // [WHEN] Creating matches for the player
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, true);

        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);
        LibraryTennisTest.CreateTennisMatchLine(TennisMatch."No.", 1, TennisPlayer."No.", "Tennis Match Team"::A, false);

        // [THEN] Flow fields should reflect the match statistics
        TennisPlayer.CalcFields("Total Matches", "Matches Won");
        if TennisPlayer."Total Matches" <> 2 then
            Error('Total matches should be 2');
        if TennisPlayer."Matches Won" <> 1 then
            Error('Matches won should be 1');
    end;

    local procedure Initialize()
    begin
        LibraryTennisTest.CleanupTestData();
        Commit();
    end;
}