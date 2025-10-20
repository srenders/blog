codeunit 91106 "Test Data Generator Factory"
{
    /// <summary>
    /// Factory method to get the appropriate test data generator based on table variant
    /// </summary>
    /// <param name="TableVariant">1=Original, 2=NoCovers, 3=Minimal, 4=AltCover</param>
    /// <returns>Test data generator implementing ITest Data Generator interface</returns>
    procedure GetGenerator(TableVariant: Integer): Interface "ITest Data Generator"
    var
        OriginalGenerator: Codeunit "Original Table Generator";
        NoCoversGenerator: Codeunit "No Covers Table Generator";
        MinimalGenerator: Codeunit "Minimal Keys Table Generator";
        AltCoverGenerator: Codeunit "Alt Cover Table Generator";
    begin
        case TableVariant of
            1:
                exit(OriginalGenerator);
            2:
                exit(NoCoversGenerator);
            3:
                exit(MinimalGenerator);
            4:
                exit(AltCoverGenerator);
            else
                Error('Invalid table variant: %1. Valid values are 1-4.', TableVariant);
        end;
    end;

    /// <summary>
    /// Gets all available generators
    /// </summary>
    procedure GetAllGenerators(): List of [Interface "ITest Data Generator"]
    var
        Generators: List of [Interface "ITest Data Generator"];
        i: Integer;
    begin
        for i := 1 to 4 do
            Generators.Add(GetGenerator(i));

        exit(Generators);
    end;

    /// <summary>
    /// Inserts test records into all table variants
    /// </summary>
    procedure InsertTestRecordsAllTables(NumberOfRecords: Integer)
    var
        Generators: List of [Interface "ITest Data Generator"];
        Generator: Interface "ITest Data Generator";
        DialogWindow: Dialog;
    begin
        Generators := GetAllGenerators();

        DialogWindow.Open('Populating all table variants...\Table: #1####################\Progress: #2########## / #3##########');

        foreach Generator in Generators do begin
            DialogWindow.Update(1, Generator.GetTableName());
            DialogWindow.Update(2, 0);
            DialogWindow.Update(3, NumberOfRecords);

            Generator.InsertTestRecords(NumberOfRecords);
        end;

        DialogWindow.Close();
        Message('Successfully populated all %1 table variants with %2 records each.', Generators.Count(), NumberOfRecords);
    end;

    /// <summary>
    /// Deletes test records (TEST-*) from all table variants
    /// </summary>
    procedure DeleteAllTestDataAllTables()
    var
        Generators: List of [Interface "ITest Data Generator"];
        Generator: Interface "ITest Data Generator";
    begin
        if not Confirm('This will delete all TEST-* records from all table variants.\Do you want to continue?', false) then
            exit;

        Generators := GetAllGenerators();

        foreach Generator in Generators do
            Generator.TruncateTestRecords();

        Message('All test records have been deleted from all table variants.');
    end;

    /// <summary>
    /// Deletes all records from all table variants (WARNING: destructive operation)
    /// </summary>
    procedure DeleteAllRecordsAllTables()
    var
        Generators: List of [Interface "ITest Data Generator"];
        Generator: Interface "ITest Data Generator";
    begin
        if not Confirm('WARNING: This will delete ALL records from all table variants.\Do you want to continue?', false) then
            exit;

        Generators := GetAllGenerators();

        foreach Generator in Generators do
            Generator.DeleteAllRecords();

        Message('All records have been deleted from all table variants.');
    end;

    /// <summary>
    /// Gets the count of table variants supported by this factory
    /// </summary>
    procedure GetTableVariantCount(): Integer
    begin
        exit(4);
    end;
}
