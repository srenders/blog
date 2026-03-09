query 80207 defaultDimensions
{
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'defaultDimension';
    EntitySetName = 'defaultDimensions';
    QueryType = API;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(defaultDimension; "Default Dimension")
        {
            column(tableID; "Table ID") { }
            column(no; "No.") { }
            column(dimensionCode; "Dimension Code") { }
            column(dimensionValueCode; "Dimension Value Code") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
