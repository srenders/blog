query 80204 Locations
{
    QueryType = API;
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'location';
    EntitySetName = 'locations';
    DataAccessIntent = ReadOnly;
    
    elements
    {
        dataitem(Location;Location)
        {            
            column("locationCode"; "Code") { }
            column(locationName; Name) { }
        }
    }
}