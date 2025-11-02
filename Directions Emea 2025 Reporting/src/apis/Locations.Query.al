query 70105 Locations
{
    QueryType = API;
    DataAccessIntent = ReadOnly;
    Caption = 'DEMO - Locations Query';
    QueryCategory = 'Items';
    UsageCategory = ReportsAndAnalysis;

    EntityName = 'locations';
    EntitySetName = 'locations';
    EntityCaption = 'locations';
    APIGroup = 'powerBI';
    APIVersion = 'v1.0';
    APIPublisher = 'powerBI';


    elements
    {
        dataitem(Location;Location)
        {
            column("locationCode"; "Code") { }
            column(locationName; Name) { }
        }
    }
}