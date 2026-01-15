codeunit 61108 "Tennis Page Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";
        IsInitialized: Boolean;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure TestTennisPlayerCardPage()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayerCard: TestPage "Tennis Player Card";
    begin
        // [SCENARIO] Tennis Player Card page functions correctly
        Initialize();

        // [GIVEN] Tennis Management setup and a player
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('Page Test Player', Today(), '+1234567890', 'page@test.com');

        // [WHEN] Opening the player card
        TennisPlayerCard.OpenEdit();
        TennisPlayerCard.GoToRecord(TennisPlayer);

        // [THEN] Player data should be displayed correctly
        if TennisPlayerCard.Name.Value <> TennisPlayer.Name then
            Error('Player name should be displayed correctly');
        if TennisPlayerCard."Phone No.".Value <> TennisPlayer."Phone No." then
            Error('Phone number should be displayed correctly');
        if TennisPlayerCard."E-Mail".Value <> TennisPlayer."E-Mail" then
            Error('Email should be displayed correctly');

        TennisPlayerCard.Close();
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure TestTennisMatchCardPage()
    var
        TennisMatch: Record "Tennis Match";
        TennisMatchCard: TestPage "Tennis Match Card";
    begin
        // [SCENARIO] Tennis Match Card page functions correctly
        Initialize();

        // [GIVEN] Tennis Management setup and a match
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Singles);

        // [WHEN] Opening the match card
        TennisMatchCard.OpenEdit();
        TennisMatchCard.GoToRecord(TennisMatch);

        // [THEN] Match data should be displayed correctly
        if TennisMatchCard."Match Date".AsDate() <> TennisMatch."Match Date" then
            Error('Match date should be displayed correctly');

        TennisMatchCard.Close();
    end;

    [Test]
    procedure TestTennisPlayerListPage()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayerList: TestPage "Tennis Player List";
        PlayerFound: Boolean;
    begin
        // [SCENARIO] Tennis Player List page displays players correctly
        Initialize();

        // [GIVEN] Tennis Management setup and a player
        LibraryTennisTest.CreateTennisSetup();
        TennisPlayer := LibraryTennisTest.CreateTennisPlayer('List Test Player', Today(), '', '');

        // [WHEN] Opening the player list
        TennisPlayerList.OpenView();

        // [THEN] Player should be visible in the list
        PlayerFound := false;
        TennisPlayerList.First();
        repeat
            if TennisPlayerList."No.".Value = TennisPlayer."No." then begin
                PlayerFound := true;
                if TennisPlayerList.Name.Value <> TennisPlayer.Name then
                    Error('Player name should be displayed correctly in list');
            end;
        until not TennisPlayerList.Next();

        if not PlayerFound then
            Error('Player should be found in the list');

        TennisPlayerList.Close();
    end;

    [Test]
    procedure TestTennisMatchListPage()
    var
        TennisMatch: Record "Tennis Match";
        TennisMatchList: TestPage "Tennis Match List";
        MatchFound: Boolean;
    begin
        // [SCENARIO] Tennis Match List page displays matches correctly
        Initialize();

        // [GIVEN] Tennis Management setup and a match
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Doubles);

        // [WHEN] Opening the match list
        TennisMatchList.OpenView();

        // [THEN] Match should be visible in the list
        MatchFound := false;
        TennisMatchList.First();
        repeat
            if TennisMatchList."No.".Value = TennisMatch."No." then begin
                MatchFound := true;
                if TennisMatchList."Match Date".AsDate() <> TennisMatch."Match Date" then
                    Error('Match date should be displayed correctly in list');
            end;
        until not TennisMatchList.Next();

        if not MatchFound then
            Error('Match should be found in the list');

        TennisMatchList.Close();
    end;

    [Test]
    procedure TestTennisManagementSetupPage()
    var
        TennisSetup: Record "Tennis Setup";
        TennisManagementSetup: TestPage "Tennis Management Setup";
    begin
        // [SCENARIO] Tennis Management Setup page functions correctly
        Initialize();

        // [GIVEN] Tennis Management setup
        TennisSetup := LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Opening the setup page
        TennisManagementSetup.OpenEdit();

        // [THEN] Setup data should be displayed correctly
        if TennisManagementSetup."Player Nos.".Value <> TennisSetup."Player Nos." then
            Error('Player Nos. should be displayed correctly');
        if TennisManagementSetup."Match Nos.".Value <> TennisSetup."Match Nos." then
            Error('Match Nos. should be displayed correctly');

        TennisManagementSetup.Close();
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure TestTennisPlayerCardNewRecord()
    var
        TennisPlayer: Record "Tennis Player";
        TennisPlayerCard: TestPage "Tennis Player Card";
        PlayerName: Text;
    begin
        // [SCENARIO] New tennis player can be created through the card page
        Initialize();

        // [GIVEN] Tennis Management setup
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Creating a new player through the card page
        TennisPlayerCard.OpenNew();
        PlayerName := 'New Card Player';
        TennisPlayerCard.Name.Value := PlayerName;
        TennisPlayerCard."Date of Birth".SetValue(Today());
        TennisPlayerCard.OK().Invoke();

        // [THEN] Player should be created in the database
        TennisPlayer.SetRange(Name, PlayerName);
        if not TennisPlayer.FindFirst() then
            Error('New player should be created');

        if TennisPlayer."Date of Birth" <> Today() then
            Error('Date of birth should be saved correctly');
    end;

    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
    end;
}