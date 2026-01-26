query 60121 "Tennis Matches API"
{
    QueryType = API;
    Caption = 'Tennis Matches API';
    APIPublisher = 'tennisPublisher';
    APIGroup = 'tennis';
    APIVersion = 'v1.0';
    EntityName = 'tennisMatch';
    EntitySetName = 'tennisMatches';

    elements
    {
        dataitem(TennisMatch; "Tennis Match")
        {
            column(matchNo; "No.") { }
            column(matchDate; "Match Date") { }
            column(matchType; "Match Type") { }
            column(status; Status) { }
            column(courtNo; "Court No.") { }
        }
    }
}
