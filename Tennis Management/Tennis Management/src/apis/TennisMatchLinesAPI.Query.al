query 60122 "Tennis Match Lines API"
{
    QueryType = API;
    Caption = 'Tennis Match Lines API';
    APIPublisher = 'tennisPublisher';
    APIGroup = 'tennis';
    APIVersion = 'v1.0';
    EntityName = 'tennisMatchLine';
    EntitySetName = 'tennisMatchLines';

    elements
    {
        dataitem(TennisMatchLine; "Tennis Match Line")
        {
            column(matchNo; "Match No.") { }
            column(lineNo; "Line No.") { }
            column(playerNo; "Player No.") { }
            column(playerName; "Player Name") { }
            column(team; Team) { }
            column(winner; Winner) { }
            column(matchStatus; "Match Status") { }

            dataitem(TennisMatch; "Tennis Match")
            {
                DataItemLink = "No." = TennisMatchLine."Match No.";
                column(matchDate; "Match Date") { }
                column(matchType; "Match Type") { }
            }
        }
    }
}
