table 60103 "Tennis Match"
{
    Caption = 'Tennis Match';
    DataClassification = CustomerContent;
    DrillDownPageId = "Tennis Match List";
    LookupPageId = "Tennis Match List";

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
                    this.NoSeriesMgt.TestManual(TennisSetup."Match Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Match Date"; Date)
        {
            Caption = 'Match Date';
            DataClassification = CustomerContent;
        }
        field(3; "Match Type"; Enum "Tennis Match Type")
        {
            Caption = 'Match Type';
            DataClassification = CustomerContent;
        }
        field(4; "Status"; Enum "Tennis Match Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(5; "Court No."; Text[20])
        {
            Caption = 'Court No.';
            DataClassification = CustomerContent;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Pk; "No.")
        {
            Clustered = true;
        }
        key(Sk1; Status)
        { }
        key(Sk2; "Match Date")
        { }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            this.TennisSetup.Get();
            this.TennisSetup.TestField("Match Nos.");
            "No." := this.NoSeriesMgt.GetNextNo(this.TennisSetup."Match Nos.", WorkDate(), true);
            "No. Series" := this.TennisSetup."Match Nos.";
        end;
    end;

    var
        TennisSetup: Record "Tennis Setup";
        NoSeriesMgt: Codeunit "No. Series";

    procedure AssistEdit(OldMatch: Record "Tennis Match"): Boolean
    var
        TennisMatch: Record "Tennis Match";
    begin
        TennisMatch := Rec;
        this.TennisSetup.Get();
        this.TennisSetup.TestField("Match Nos.");
        if this.NoSeriesMgt.LookupRelatedNoSeries(this.TennisSetup."Match Nos.", OldMatch."No. Series", TennisMatch."No. Series") then begin
            TennisMatch."No." := this.NoSeriesMgt.GetNextNo(this.TennisSetup."Match Nos.");
            Rec := TennisMatch;
            exit(true);
        end;
    end;
}
