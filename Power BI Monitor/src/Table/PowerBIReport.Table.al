table 90114 "Power BI Report"
{
    Caption = 'Power BI Report';
    LookupPageId = "Power BI Reports";
    DrillDownPageId = "Power BI Reports";

    fields
    {
        field(1; "Report ID"; Guid)
        {
            Caption = 'Report ID';
            DataClassification = SystemMetadata;
        }
        field(2; "Workspace ID"; Guid)
        {
            Caption = 'Workspace ID';
            DataClassification = SystemMetadata;
            TableRelation = "Power BI Workspace"."Workspace ID";
        }
        field(10; Name; Text[250])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(11; "Web URL"; Text[250])
        {
            Caption = 'Web URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(12; "Embed URL"; Text[250])
        {
            Caption = 'Embed URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(20; "Dataset ID"; Guid)
        {
            Caption = 'Dataset ID';
            DataClassification = SystemMetadata;
            TableRelation = "Power BI Dataset"."Dataset ID";
        }
        field(21; "Dataset Name"; Text[250])
        {
            Caption = 'Dataset Name';
            DataClassification = CustomerContent;
        }
        field(30; "Report Type"; Text[50])
        {
            Caption = 'Report Type';
            DataClassification = SystemMetadata;
        }
        field(31; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = SystemMetadata;
        }
        field(32; "Modified Date"; DateTime)
        {
            Caption = 'Modified Date';
            DataClassification = SystemMetadata;
        }
        field(40; "Modified By"; Text[100])
        {
            Caption = 'Modified By';
            DataClassification = SystemMetadata;
        }
        field(41; "App ID"; Text[100])
        {
            Caption = 'App ID';
            DataClassification = SystemMetadata;
        }
        field(42; "Is From PBI Service"; Boolean)
        {
            Caption = 'Is From Power BI Service';
            DataClassification = SystemMetadata;
        }
        field(43; "Is Owned By Me"; Boolean)
        {
            Caption = 'Is Owned By Me';
            DataClassification = SystemMetadata;
        }
        field(50; "Workspace Name"; Text[250])
        {
            Caption = 'Workspace Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Power BI Workspace"."Workspace Name" where("Workspace ID" = field("Workspace ID")));
            Editable = false;
        }
        field(100; "Last Sync"; DateTime)
        {
            Caption = 'Last Sync';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Report ID", "Workspace ID")
        {
            Clustered = true;
        }
        key(Name; Name)
        {
        }
        key(Modified; "Modified Date")
        {
        }
    }
}