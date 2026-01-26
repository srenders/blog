table 60102 "Tennis Match Line"
{
    Caption = 'Tennis Match Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Match No."; Code[20])
        {
            Caption = 'Match No.';
            TableRelation = "Tennis Match";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Player No."; Code[20])
        {
            Caption = 'Player No.';
            TableRelation = "Tennis Player";

            trigger OnValidate()
            var
                TennisPlayer: Record "Tennis Player";
            begin
                if TennisPlayer.Get("Player No.") then
                    "Player Name" := TennisPlayer.Name
                else
                    "Player Name" := '';
            end;
        }
        field(4; "Player Name"; Text[100])
        {
            Caption = 'Player Name';
            Editable = false;
        }
        field(5; "Team"; Enum "Tennis Match Team")
        {
            Caption = 'Team';
        }
        field(6; "Winner"; Boolean)
        {
            Caption = 'Winner';

            trigger OnValidate()
            var
                TennisMatchLine: Record "Tennis Match Line";
            begin
                if Winner then begin
                    TennisMatchLine.SetRange("Match No.", "Match No.");
                    TennisMatchLine.SetRange(Team, Team);
                    TennisMatchLine.SetFilter("Line No.", '<>%1', "Line No.");
                    if TennisMatchLine.FindSet() then
                        repeat
                            TennisMatchLine.Winner := true;
                            TennisMatchLine.Modify();
                        until TennisMatchLine.Next() = 0;

                    TennisMatchLine.Reset();
                    TennisMatchLine.SetRange("Match No.", "Match No.");
                    TennisMatchLine.SetFilter(Team, '<>%1', Team);
                    if TennisMatchLine.FindSet() then
                        repeat
                            TennisMatchLine.Winner := false;
                            TennisMatchLine.Modify();
                        until TennisMatchLine.Next() = 0;
                end;
            end;
        }
        field(7; "Match Status"; Enum "Tennis Match Status")
        {
            Caption = 'Match Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Tennis Match".Status where("No." = field("Match No.")));
        }
    }

    keys
    {
        key(Key1; "Match No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Player No.")
        {
        }
    }
}
