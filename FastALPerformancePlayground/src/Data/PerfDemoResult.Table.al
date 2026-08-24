table 70200 "Perf Demo Result"
{
    Caption = 'Performance Demo Result';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Demo Code"; Code[30])
        {
            Caption = 'Demo Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Duration; Duration)
        {
            Caption = 'Duration';
        }
        field(4; "SQL Statements"; BigInteger)
        {
            Caption = 'SQL Statements';
        }
        field(5; "Rows Read"; BigInteger)
        {
            Caption = 'Rows Read';
        }
        field(6; "Result Value"; Decimal)
        {
            Caption = 'Result Value';
            DecimalPlaces = 0 : 5;
        }
        field(7; "Last Run At"; DateTime)
        {
            Caption = 'Last Run At';
        }
        field(8; Notes; Text[250])
        {
            Caption = 'Notes';
        }
        field(9; "Run No."; Integer)
        {
            Caption = 'Run No.';
        }
    }

    keys
    {
        key(PK; "Demo Code", "Run No.")
        {
            Clustered = true;
        }
    }
}
