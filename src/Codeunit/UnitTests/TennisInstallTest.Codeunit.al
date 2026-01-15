codeunit 61106 "Tennis Install Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTennisTest: Codeunit "Library - Tennis Test";
        IsInitialized: Boolean;

    [Test]
    procedure TestNumberSeriesStructure()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        // [SCENARIO] Number series are structured correctly for Tennis Management
        Initialize();

        // [GIVEN] We create the expected number series setup
        LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Checking the number series
        if not NoSeries.Get('PLAYERS') then
            Error('PLAYERS number series should exist');

        if not NoSeries.Get('MATCHES') then
            Error('MATCHES number series should exist');

        // [THEN] Number series should have correct properties
        NoSeriesLine.SetRange("Series Code", 'PLAYERS');
        if NoSeriesLine.IsEmpty() then
            Error('PLAYERS number series line should exist');

        NoSeriesLine.SetRange("Series Code", 'MATCHES');
        if NoSeriesLine.IsEmpty() then
            Error('MATCHES number series line should exist');
    end;

    [Test]
    procedure TestSetupIntegrity()
    var
        TennisSetup: Record "Tennis Setup";
        NoSeries: Record "No. Series";
    begin
        // [SCENARIO] Tennis Setup references valid number series
        Initialize();

        // [GIVEN] Complete setup
        TennisSetup := LibraryTennisTest.CreateTennisSetup();

        // [WHEN] Checking setup integrity
        // [THEN] Referenced number series should exist
        if not NoSeries.Get(TennisSetup."Player Nos.") then
            Error('Player number series referenced in setup should exist');

        if not NoSeries.Get(TennisSetup."Match Nos.") then
            Error('Match number series referenced in setup should exist');
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
    end;
}