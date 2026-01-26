codeunit 61104 "Tennis Setup Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";

    [Test]
    procedure TestTennisSetupCreation()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        // [SCENARIO] Tennis setup can be created
        Initialize();

        // [WHEN] Creating tennis setup
        TennisSetup := LibraryTennisTest.CreateTennisSetup();

        // [THEN] Setup should be created with correct values
        if TennisSetup."Player Nos." = '' then
            Error('Player Nos. should not be empty');
        if TennisSetup."Match Nos." = '' then
            Error('Match Nos. should not be empty');
    end;

    [Test]
    procedure TestTennisSetupSingleton()
    var
        TennisSetup1, TennisSetup2 : Record "Tennis Setup";
    begin
        // [SCENARIO] Only one Tennis Setup record can exist
        Initialize();

        // [GIVEN] A tennis setup exists
        TennisSetup1 := LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Getting the setup record
        TennisSetup2.Get();

        // [THEN] Both records should be the same
        if TennisSetup1."Player Nos." <> TennisSetup2."Player Nos." then
            Error('Player Nos. should match');
        if TennisSetup1."Match Nos." <> TennisSetup2."Match Nos." then
            Error('Match Nos. should match');
    end;

    [Test]
    procedure TestTennisSetupModification()
    var
        TennisSetup: Record "Tennis Setup";
        NewPlayerNos: Code[20];
        NewMatchNos: Code[20];
    begin
        // [SCENARIO] Tennis setup can be modified
        Initialize();

        // [GIVEN] A tennis setup exists
        TennisSetup := LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Modifying the setup
        NewPlayerNos := 'NEWPLAYERS';
        NewMatchNos := 'NEWMATCHES';
        TennisSetup."Player Nos." := NewPlayerNos;
        TennisSetup."Match Nos." := NewMatchNos;
        TennisSetup.Modify();

        // [THEN] Changes should be saved
        TennisSetup.Get();
        if TennisSetup."Player Nos." <> NewPlayerNos then
            Error('Player Nos. should be updated');
        if TennisSetup."Match Nos." <> NewMatchNos then
            Error('Match Nos. should be updated');
    end;

    local procedure Initialize()
    begin
        LibraryTennisTest.CleanupTestData();
        Commit();
    end;
}