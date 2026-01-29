table 60200 "TAI Service Decl. Fix Setup"
{
    Caption = 'TAI Service Declaration Correction Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Default Serv. Trans. Type Code"; Code[20])
        {
            Caption = 'Default Service Transaction Type Code';
            TableRelation = "Service Transaction Type";
            DataClassification = CustomerContent;
        }
        field(20; "Filter Method"; Enum "TAI Serv. Decl. Filter Method")
        {
            Caption = 'Filter Method';
            DataClassification = CustomerContent;
        }
        field(30; "Limit to EU Countries"; Boolean)
        {
            Caption = 'Limit to EU Countries';
            DataClassification = CustomerContent;
        }
        field(40; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(50; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("Ending Date" <> 0D) and ("Starting Date" <> 0D) then
                    if "Ending Date" < "Starting Date" then
                        Error(EndingDateErr);
            end;
        }
        field(100; "Last Run Date"; DateTime)
        {
            Caption = 'Last Run Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(110; "Lines Created"; Integer)
        {
            Caption = 'Lines Created';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        EndingDateErr: Label 'Ending Date cannot be earlier than Starting Date.';

    procedure GetSetup(): Record "TAI Service Decl. Fix Setup"
    begin
        if not Get() then begin
            Init();
            "Primary Key" := '';
            Insert();
        end;
        exit(Rec);
    end;
}
