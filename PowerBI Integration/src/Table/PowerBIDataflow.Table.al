table 90113 "Power BI Dataflow"
{
    DataClassification = ToBeClassified;
    Caption = 'Power BI Dataflow';

    fields
    {
        field(1; "Dataflow ID"; Guid)
        {
            DataClassification = SystemMetadata;
            Caption = 'Dataflow ID';
        }
        field(2; "Workspace ID"; Guid)
        {
            DataClassification = SystemMetadata;
            Caption = 'Workspace ID';
            TableRelation = "Power BI Workspace"."Workspace ID";
        }
        field(10; "Dataflow Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Dataflow Name';
        }
        field(11; "Description"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(12; "Web URL"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Web URL';
        }
        field(13; "Configured By"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Configured By';
        }
        field(20; "Last Refresh"; DateTime)
        {
            DataClassification = SystemMetadata;
            Caption = 'Last Refresh';
        }
        field(21; "Last Refresh Status"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Last Refresh Status';
        }
        field(22; "Last Refresh Duration (Min)"; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'Last Refresh Duration (Minutes)';
            DecimalPlaces = 2 : 2;
        }
        field(23; "Average Refresh Duration (Min)"; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'Average Refresh Duration (Minutes)';
            DecimalPlaces = 2 : 2;
        }
        field(24; "Refresh Count"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Refresh Count';
        }
        field(30; "Last Synchronized"; DateTime)
        {
            DataClassification = SystemMetadata;
            Caption = 'Last Synchronized';
        }
    }

    keys
    {
        key(PK; "Dataflow ID", "Workspace ID")
        {
            Clustered = true;
        }
        key(WorkspaceKey; "Workspace ID", "Dataflow Name")
        {
        }
        key(LastRefreshKey; "Last Refresh")
        {
        }
    }
}