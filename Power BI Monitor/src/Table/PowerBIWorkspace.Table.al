table 90110 "Power BI Workspace"
{
    Caption = 'Power BI Workspace';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Workspace ID"; Guid)
        {
            Caption = 'Workspace ID';
        }

        field(2; "Workspace Name"; Text[100])
        {
            Caption = 'Workspace Name';
        }

        field(3; "Workspace Type"; Text[50])
        {
            Caption = 'Workspace Type';
        }

        field(4; "Is Read Only"; Boolean)
        {
            Caption = 'Is Read Only';
        }

        field(5; "Last Synchronized"; DateTime)
        {
            Caption = 'Last Synchronized';
        }

        field(6; "Sync Enabled"; Boolean)
        {
            Caption = 'Sync Enabled';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Workspace ID")
        {
            Clustered = true;
        }

        key(Name; "Workspace Name") { }
    }

    trigger OnInsert()
    begin
        "Last Synchronized" := CurrentDateTime();
    end;
}