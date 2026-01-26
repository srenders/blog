query 60120 "Tennis Players API"
{
    QueryType = API;
    Caption = 'Tennis Players API';
    APIPublisher = 'tennisPublisher';
    APIGroup = 'tennis';
    APIVersion = 'v1.0';
    EntityName = 'tennisPlayer';
    EntitySetName = 'tennisPlayers';

    elements
    {
        dataitem(TennisPlayer; "Tennis Player")
        {
            column(playerNo; "No.") { }
            column(playerName; Name) { }
            column(dateOfBirth; "Date of Birth") { }
            column(phoneNo; "Phone No.") { }
            column(email; "E-Mail") { }
            column(totalMatches; "Total Matches") { }
            column(matchesWon; "Matches Won") { }
        }
    }
}
