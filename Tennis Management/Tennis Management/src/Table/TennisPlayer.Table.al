table 60100 "Tennis Player"
{
    Caption = 'Tennis Player';
    DataClassification = CustomerContent;
    DrillDownPageId = "Tennis Player List";
    LookupPageId = "Tennis Player List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    this.TennisSetup.Get();
                    this.NoSeriesMgt.TestManual(this.TennisSetup."Player Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
        }
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
        }
        field(5; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
        field(10; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; "Total Matches"; Integer)
        {
            Caption = 'Total Matches';
            FieldClass = FlowField;
            CalcFormula = count("Tennis Match Line" where("Player No." = field("No.")));
            Editable = false;
        }
        field(21; "Matches Won"; Integer)
        {
            Caption = 'Matches Won';
            FieldClass = FlowField;
            CalcFormula = count("Tennis Match Line" where("Player No." = field("No."), Winner = const(true)));
            Editable = false;
        }
        field(22; "Matches Lost"; Integer)
        {
            Caption = 'Matches Lost';
            FieldClass = FlowField;
            CalcFormula = count("Tennis Match Line" where("Player No." = field("No."), Winner = const(false),
                                                        "Match Status" = const(Finished)));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            this.TennisSetup.Get();
            this.TennisSetup.TestField("Player Nos.");
            "No." := this.NoSeriesMgt.GetNextNo(this.TennisSetup."Player Nos.", WorkDate(), true);
            "No. Series" := this.TennisSetup."Player Nos.";
        end;
    end;

    var
        TennisSetup: Record "Tennis Setup";
        NoSeriesMgt: Codeunit "No. Series";

    procedure AssistEdit(OldTennisPlayer: Record "Tennis Player"): Boolean
    var
        TennisPlayer: Record "Tennis Player";
    begin
        TennisPlayer := Rec;
        this.TennisSetup.Get();
        this.TennisSetup.TestField("Player Nos.");
        if this.NoSeriesMgt.LookupRelatedNoSeries(this.TennisSetup."Player Nos.", OldTennisPlayer."No. Series", TennisPlayer."No. Series") then begin
            TennisPlayer."No." := this.NoSeriesMgt.GetNextNo(TennisSetup."Player Nos.");
            Rec := TennisPlayer;
            exit(true);
        end;
    end;
}
