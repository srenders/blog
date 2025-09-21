table 90111 "Power BI Dataset"
{
    Caption = 'Power BI Dataset';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Dataset ID"; Guid)
        {
            Caption = 'Dataset ID';
        }

        field(2; "Workspace ID"; Guid)
        {
            Caption = 'Workspace ID';
            TableRelation = "Power BI Workspace"."Workspace ID";
        }

        field(3; "Dataset Name"; Text[100])
        {
            Caption = 'Dataset Name';
        }

        field(4; "Web URL"; Text[250])
        {
            Caption = 'Web URL';
        }

        field(5; "Configured By"; Text[100])
        {
            Caption = 'Configured By';
        }

        field(6; "Is Refreshable"; Boolean)
        {
            Caption = 'Is Refreshable';
        }

        field(7; "Last Refresh"; DateTime)
        {
            Caption = 'Last Refresh';
        }

        field(8; "Last Refresh Status"; Text[50])
        {
            Caption = 'Last Refresh Status';
        }

        field(9; "Last Refresh Duration (Min)"; Decimal)
        {
            Caption = 'Last Refresh Duration (Min)';
            DecimalPlaces = 2 : 2;
        }

        field(10; "Average Refresh Duration (Min)"; Decimal)
        {
            Caption = 'Average Refresh Duration (Min)';
            DecimalPlaces = 2 : 2;
        }

        field(11; "Refresh Count"; Integer)
        {
            Caption = 'Refresh Count';
        }

        field(12; "Last Synchronized"; DateTime)
        {
            Caption = 'Last Synchronized';
        }
    }

    keys
    {
        key(PK; "Dataset ID", "Workspace ID")
        {
            Clustered = true;
        }

        key(Workspace; "Workspace ID") { }

        key(Name; "Dataset Name") { }

        key(LastRefresh; "Last Refresh") { }
    }

    trigger OnInsert()
    begin
        "Last Synchronized" := CurrentDateTime();
    end;
}