codeunit 61105 "Tennis Assisted Setup Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";
        TennisAssistedSetup: Codeunit "Tennis Assisted Setup";

    [Test]
    procedure TestAssistedSetupRegistration()
    begin
        // [SCENARIO] Tennis Assisted Setup can be registered
        Initialize();

        // [WHEN] Registering assisted setup
        TennisAssistedSetup.RegisterAssistedSetup();

        // [THEN] No error should occur
        // The test passes if no exception is thrown
    end;

    [Test]
    procedure TestIsAssistedSetupCompleteWithoutSetup()
    var
        TennisSetup: Record "Tennis Setup";
        IsComplete: Boolean;
    begin
        // [SCENARIO] Assisted setup is not complete when setup doesn't exist
        Initialize();

        // [GIVEN] No Tennis Setup exists
        if TennisSetup.Get() then
            TennisSetup.Delete();

        // [WHEN] Checking if assisted setup is complete
        IsComplete := TennisAssistedSetup.IsAssistedSetupComplete();

        // [THEN] Setup should not be complete
        if IsComplete then
            Error('Setup should not be complete without Tennis Setup record');
    end;

    [Test]
    procedure TestIsAssistedSetupCompleteWithIncompleteSetup()
    var
        TennisSetup: Record "Tennis Setup";
        IsComplete: Boolean;
    begin
        // [SCENARIO] Assisted setup is not complete with incomplete setup
        Initialize();

        // [GIVEN] Tennis Setup exists but is incomplete
        if TennisSetup.Get() then
            TennisSetup.Delete();

        TennisSetup.Init();
        TennisSetup."Primary Key" := '';
        TennisSetup."Player Nos." := 'PLAYER';
        TennisSetup."Match Nos." := ''; // Missing match numbers
        TennisSetup.Insert();

        // [WHEN] Checking if assisted setup is complete
        IsComplete := TennisAssistedSetup.IsAssistedSetupComplete();

        // [THEN] Setup should not be complete
        if IsComplete then
            Error('Setup should not be complete with missing Match Nos.');
    end;

    [Test]
    procedure TestIsAssistedSetupCompleteWithCompleteSetup()
    var
        IsComplete: Boolean;
    begin
        // [SCENARIO] Assisted setup is complete with complete setup
        Initialize();

        // [GIVEN] Complete Tennis Setup exists
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Checking if assisted setup is complete
        IsComplete := TennisAssistedSetup.IsAssistedSetupComplete();

        // [THEN] Setup should be complete
        if not IsComplete then
            Error('Setup should be complete with all required fields');
    end;

    [Test]
    procedure TestRunAssistedSetup()
    var
        TennisSetup: Record "Tennis Setup";
    begin
        // [SCENARIO] Assisted setup can be run
        Initialize();

        // [GIVEN] No Tennis Setup exists
        if TennisSetup.Get() then
            TennisSetup.Delete();

        // [WHEN] Running assisted setup (this will create empty setup record)
        // We can't fully test the interactive part, but we can test the setup
        TennisAssistedSetup.RegisterAssistedSetup();

        // [THEN] No error should occur during registration
        // The test passes if no exception is thrown
    end;

    local procedure Initialize()
    begin
        LibraryTennisTest.CleanupTestData();
        Commit();
    end;
}