table 60101 "Tennis Setup"
{
    Caption = 'Tennis Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
            
        }
        field(10; "Player Nos."; Code[20])
        {
            Caption = 'Player Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(20; "Match Nos."; Code[20])
        {
            Caption = 'Match Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}
