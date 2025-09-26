table 90115 "Power BI Dashboard"
{
    Caption = 'Power BI Dashboard';
    DataClassification = CustomerContent;
    LookupPageId = 90140;
    DrillDownPageId = 90140;

    fields
    {
        field(1; "Dashboard ID"; Guid)
        {
            Caption = 'Dashboard ID';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(2; "Dashboard Name"; Text[250])
        {
            Caption = 'Dashboard Name';
            DataClassification = CustomerContent;
        }

        field(3; "Workspace ID"; Guid)
        {
            Caption = 'Workspace ID';
            DataClassification = CustomerContent;
            TableRelation = "Power BI Workspace"."Workspace ID";
        }

        field(4; "Workspace Name"; Text[250])
        {
            Caption = 'Workspace Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Power BI Workspace"."Workspace Name" where("Workspace ID" = field("Workspace ID")));
            Editable = false;
        }

        field(5; "Web URL"; Text[2048])
        {
            Caption = 'Web URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }

        field(6; "Embed URL"; Text[2048])
        {
            Caption = 'Embed URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }

        field(7; "Is ReadOnly"; Boolean)
        {
            Caption = 'Is ReadOnly';
            DataClassification = CustomerContent;
        }

        field(8; "Is Featured"; Boolean)
        {
            Caption = 'Is Featured';
            DataClassification = CustomerContent;
        }

        field(10; "Display Name"; Text[250])
        {
            Caption = 'Display Name';
            DataClassification = CustomerContent;
        }

        field(11; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(12; "Modified Date"; DateTime)
        {
            Caption = 'Modified Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(13; "Last Sync Date"; DateTime)
        {
            Caption = 'Last Sync Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(20; "Tile Count"; Integer)
        {
            Caption = 'Tile Count';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(21; "Is Synced"; Boolean)
        {
            Caption = 'Is Synced';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Dashboard ID")
        {
            Clustered = true;
        }
        key(WorkspaceKey; "Workspace ID", "Dashboard Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Dashboard Name", "Workspace Name", "Is ReadOnly")
        {
        }
        fieldgroup(Brick; "Dashboard Name", "Workspace Name", "Tile Count")
        {
        }
    }

    trigger OnInsert()
    begin
        "Last Sync Date" := CurrentDateTime();
        "Is Synced" := true;
    end;

    trigger OnModify()
    begin
        "Last Sync Date" := CurrentDateTime();
    end;

    procedure OpenInPowerBI()
    begin
        if "Web URL" <> '' then
            Hyperlink("Web URL");
    end;

    procedure GetEmbedInfo(): Text
    begin
        if "Embed URL" <> '' then
            exit("Embed URL");
        exit('');
    end;

    procedure RefreshTileCount(): Boolean
    var
        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
    begin
        exit(PowerBIAPIOrchestrator.GetDashboardTiles("Dashboard ID"));
    end;
}