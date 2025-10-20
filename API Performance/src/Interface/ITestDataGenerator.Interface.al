interface "ITest Data Generator"
{
    /// <summary>
    /// Inserts test records into the target table
    /// </summary>
    /// <param name="NumberOfRecords">Number of test records to insert</param>
    procedure InsertTestRecords(NumberOfRecords: Integer)

    /// <summary>
    /// Deletes only test records (Document No. starting with TEST-) from the target table
    /// </summary>
    procedure TruncateTestRecords()

    /// <summary>
    /// Deletes all records from the target table
    /// </summary>
    procedure DeleteAllRecords()

    /// <summary>
    /// Gets the next available entry number for the target table
    /// </summary>
    /// <returns>Next entry number</returns>
    procedure GetNextEntryNo(): Integer

    /// <summary>
    /// Gets the name/caption of the table this generator works with
    /// </summary>
    /// <returns>Table name</returns>
    procedure GetTableName(): Text[100]
}
