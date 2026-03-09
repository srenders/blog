query 80208 dimensionSetEntries
{
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'dimensionSetEntries';
    EntitySetName = 'dimensionSetEntries';
    QueryType = API;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(dimensionSetEntry; "Dimension Set Entry")
        {
            column(dimensionCode; "Dimension Code") { }
            column(dimensionName; "Dimension Name") { }
            column(dimensionSetID; "Dimension Set ID") { }
            column(dimensionValueCode; "Dimension Value Code") { }
            column(dimensionValueID; "Dimension Value ID") { }
            column(dimensionValueName; "Dimension Value Name") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
