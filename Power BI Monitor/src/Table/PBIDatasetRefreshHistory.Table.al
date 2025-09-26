table 90120 "PBI Dataset Refresh History"
{
    Caption = 'PBI Dataset Refresh History';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }

        field(10; "Dataset ID"; Text[250])
        {
            Caption = 'Dataset ID';
            DataClassification = CustomerContent;
        }

        field(11; "Dataset Name"; Text[250])
        {
            Caption = 'Dataset Name';
            DataClassification = CustomerContent;
        }

        field(12; "Workspace ID"; Text[250])
        {
            Caption = 'Workspace ID';
            DataClassification = CustomerContent;
        }

        field(13; "Workspace Name"; Text[250])
        {
            Caption = 'Workspace Name';
            DataClassification = CustomerContent;
        }

        field(20; "Refresh ID"; Text[250])
        {
            Caption = 'Refresh ID';
            DataClassification = CustomerContent;
        }

        field(21; "Refresh Type"; Text[50])
        {
            Caption = 'Refresh Type';
            DataClassification = CustomerContent;
        }

        field(30; "Start Time"; DateTime)
        {
            Caption = 'Start Time';
            DataClassification = CustomerContent;
        }

        field(31; "End Time"; DateTime)
        {
            Caption = 'End Time';
            DataClassification = CustomerContent;
        }

        field(32; "Duration (Minutes)"; Decimal)
        {
            Caption = 'Duration (Minutes)';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }

        field(40; "Status"; Enum "Power BI Refresh Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }

        field(41; "Status Code"; Integer)
        {
            Caption = 'Status Code';
            DataClassification = CustomerContent;
        }

        field(42; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }

        field(50; "Service Exception Json"; Blob)
        {
            Caption = 'Service Exception Json';
            DataClassification = CustomerContent;
        }

        field(60; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(61; "Last Synchronized"; DateTime)
        {
            Caption = 'Last Synchronized';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(Dataset; "Dataset ID", "Start Time")
        {
        }

        key(Workspace; "Workspace ID", "Start Time")
        {
        }

        key(RefreshId; "Refresh ID")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;
        "Last Synchronized" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Synchronized" := CurrentDateTime;
    end;

    /// <summary>
    /// Calculate duration in minutes from start and end time
    /// </summary>
    procedure CalculateDuration()
    begin
        if ("Start Time" <> 0DT) and ("End Time" <> 0DT) and ("End Time" > "Start Time") then
            "Duration (Minutes)" := Round(("End Time" - "Start Time") / 60000, 0.01)
        else
            "Duration (Minutes)" := 0;
    end;

    /// <summary>
    /// Get service exception as text from blob
    /// </summary>
    procedure GetServiceExceptionText(): Text
    var
        InStream: InStream;
        ExceptionText: Text;
    begin
        if not "Service Exception Json".HasValue() then
            exit('');

        "Service Exception Json".CreateInStream(InStream);
        InStream.ReadText(ExceptionText);
        exit(ExceptionText);
    end;

    /// <summary>
    /// Set service exception text to blob
    /// </summary>
    procedure SetServiceExceptionText(ExceptionText: Text)
    var
        OutStream: OutStream;
    begin
        "Service Exception Json".CreateOutStream(OutStream);
        OutStream.WriteText(ExceptionText);
    end;
}