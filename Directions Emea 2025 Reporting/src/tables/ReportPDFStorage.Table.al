table 70122 "Report PDF Storage"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            DataClassification = CustomerContent;
        }
        field(2; "PDF File"; Media)
        {
            Caption = 'PDF File';
            DataClassification = CustomerContent;
        }
        field(3; "Last Updated"; DateTime)
        {
            Caption = 'Last Updated';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Report ID")
        {
            Clustered = true;
        }
    }
}
