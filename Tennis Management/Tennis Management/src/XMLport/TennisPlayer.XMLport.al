xmlport 60125 "Tennis Player"
{
    Caption = 'Tennis Player Import/Export';
    Direction = Both;
    Format = Xml;
    Encoding = UTF8;
    UseRequestPage = true;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(TennisPlayer; "Tennis Player")
            {
                XmlName = 'TennisPlayer';
                fieldelement(Number; TennisPlayer."No.") { }
                fieldelement(Name; TennisPlayer.Name) { }
                fieldelement(DateOfBirth; TennisPlayer."Date of Birth") { }
                fieldelement(PhoneNo; TennisPlayer."Phone No.") { }
                fieldelement(Email; TennisPlayer."E-Mail") { }

                trigger OnBeforeInsertRecord()
                begin
                    if this.PlayerExists(TennisPlayer."No.") then
                        currXMLport.Skip();
                end;
            }
        }
    }


    local procedure PlayerExists(PlayerNo: Code[20]): Boolean
    var
        Player: Record "Tennis Player";
    begin
        exit(Player.Get(PlayerNo));
    end;
}
