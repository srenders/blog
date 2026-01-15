codeunit 61102 "Tennis Match Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";
        IsInitialized: Boolean;

    [Test]
    procedure TestTennisMatchCreation()
    var
        TennisMatch: Record "Tennis Match";
        MatchNo: Code[20];
    begin
        // [SCENARIO] A tennis match can be created with automatic numbering
        Initialize();

        // [GIVEN] Tennis Management setup is configured
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Creating a new tennis match
        TennisMatch.Init();
        TennisMatch.Insert(true);
        MatchNo := TennisMatch."No.";

        // [THEN] Match should be created with auto-generated number
        if MatchNo = '' then
            Error('Match number should not be empty');
        TennisMatch.Get(MatchNo);
        if TennisMatch."No. Series" = '' then
            Error('No. Series should be populated');
    end;

    [Test]
    procedure TestTennisMatchFields()
    var
        TennisMatch: Record "Tennis Match";
        MatchDate: Date;
    begin
        // [SCENARIO] Tennis match fields are set correctly
        Initialize();

        // [GIVEN] Tennis Management setup is configured
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Creating a tennis match with specific data
        MatchDate := Today();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(MatchDate, "Tennis Match Type"::Singles);

        // [THEN] Match should have correct field values
        if TennisMatch."Match Date" <> MatchDate then
            Error('Match date should match');
        if TennisMatch."Match Type" <> "Tennis Match Type"::Singles then
            Error('Match type should be Singles');
        if TennisMatch.Status <> TennisMatch.Status::Open then
            Error('Match status should be Open');
    end;

    [Test]
    procedure TestTennisMatchStatusChange()
    var
        TennisMatch: Record "Tennis Match";
    begin
        // [SCENARIO] Tennis match status can be changed
        Initialize();

        // [GIVEN] Tennis Management setup and an open match
        LibraryTennisTest.CreateTennisSetup();
        TennisMatch := LibraryTennisTest.CreateTennisMatch(Today(), "Tennis Match Type"::Doubles);

        // [WHEN] Finishing the match
        LibraryTennisTest.FinishTennisMatch(TennisMatch);

        // [THEN] Match status should be finished
        if TennisMatch.Status <> TennisMatch.Status::Finished then
            Error('Match status should be Finished');
    end;

    [Test]
    procedure TestTennisMatchWithCustomNumber()
    var
        TennisMatch: Record "Tennis Match";
        CustomMatchNo: Code[20];
    begin
        // [SCENARIO] Tennis match can be created with custom number
        Initialize();

        // [GIVEN] Tennis Management setup is configured
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Creating a match with custom number
        CustomMatchNo := 'MATCH001';
        TennisMatch.Init();
        TennisMatch."No." := CustomMatchNo;
        TennisMatch."Match Date" := Today();
        TennisMatch."Match Type" := "Tennis Match Type"::Singles;
        TennisMatch.Insert(true);

        // [THEN] Match should be created with custom number
        if TennisMatch."No." <> CustomMatchNo then
            Error('Match number should match custom value');
        if TennisMatch."No. Series" <> '' then
            Error('No. Series should be empty for manual numbers');
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
    end;
}