codeunit 91100 "Simple Transaction Test Data"
{
    // REFACTORED: This codeunit now delegates to the Factory pattern
    // following SOLID principles (Open/Closed, Dependency Inversion)

    var
        Factory: Codeunit "Test Data Generator Factory";

    // ===== ORIGINAL TABLE (91100) =====
    procedure InsertTestRecords(NumberOfRecords: Integer)
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(1); // Original table
        Generator.InsertTestRecords(NumberOfRecords);
    end;

    procedure TruncateTestRecords()
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(1);
        Generator.TruncateTestRecords();
    end;

    procedure DeleteAllRecords()
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(1);
        Generator.DeleteAllRecords();
    end;

    // ===== NO COVERING INDEXES TABLE (91103) =====
    procedure InsertTestRecordsNoCovers(NumberOfRecords: Integer)
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(2); // No Covers table
        Generator.InsertTestRecords(NumberOfRecords);
    end;

    procedure TruncateTestRecordsNoCovers()
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(2);
        Generator.TruncateTestRecords();
    end;

    procedure DeleteAllRecordsNoCovers()
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(2);
        Generator.DeleteAllRecords();
    end;

    // ===== MINIMAL KEYS TABLE (91104) =====
    procedure InsertTestRecordsMinimal(NumberOfRecords: Integer)
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(3); // Minimal Keys table
        Generator.InsertTestRecords(NumberOfRecords);
    end;

    procedure TruncateTestRecordsMinimal()
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(3);
        Generator.TruncateTestRecords();
    end;

    procedure DeleteAllRecordsMinimal()
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(3);
        Generator.DeleteAllRecords();
    end;

    // ===== ALTERNATIVE COVERING TABLE (91105) =====
    procedure InsertTestRecordsAltCover(NumberOfRecords: Integer)
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(4); // Alternative Covering table
        Generator.InsertTestRecords(NumberOfRecords);
    end;

    procedure TruncateTestRecordsAltCover()
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(4);
        Generator.TruncateTestRecords();
    end;

    procedure DeleteAllRecordsAltCover()
    var
        Generator: Interface "ITest Data Generator";
    begin
        Generator := Factory.GetGenerator(4);
        Generator.DeleteAllRecords();
    end;

    // ===== BULK OPERATIONS FOR ALL TABLES =====
    procedure InsertTestRecordsAllTables(NumberOfRecords: Integer)
    begin
        Factory.InsertTestRecordsAllTables(NumberOfRecords);
    end;

    procedure DeleteAllTestDataAllTables()
    begin
        Factory.DeleteAllTestDataAllTables();
    end;

    procedure DeleteAllRecordsAllTables()
    begin
        Factory.DeleteAllRecordsAllTables();
    end;
}