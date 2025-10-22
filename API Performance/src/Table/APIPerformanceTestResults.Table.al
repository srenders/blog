table 91106 "API Performance Test Results"
{
    Caption = 'API Performance Test Results';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }

        field(2; "Test Run No."; Integer)
        {
            Caption = 'Test Run No.';
            DataClassification = CustomerContent;
        }

        field(3; "Test Run DateTime"; DateTime)
        {
            Caption = 'Test Run DateTime';
            DataClassification = CustomerContent;
        }

        field(4; "Test Type"; Enum "Performance Test Type")
        {
            Caption = 'Test Type';
            DataClassification = CustomerContent;
        }

        field(5; "Table Variant"; Enum "Table Variant Type")
        {
            Caption = 'Table Variant';
            DataClassification = CustomerContent;
        }

        field(6; "API Type"; Enum "API Type")
        {
            Caption = 'API Type';
            DataClassification = CustomerContent;
        }

        field(7; "Duration (ms)"; Duration)
        {
            Caption = 'Duration (ms)';
            DataClassification = CustomerContent;
        }

        field(8; "Record Count"; Integer)
        {
            Caption = 'Record Count';
            DataClassification = CustomerContent;
        }

        field(9; "Test Description"; Text[250])
        {
            Caption = 'Test Description';
            DataClassification = CustomerContent;
        }

        field(10; "Filter Applied"; Text[250])
        {
            Caption = 'Filter Applied';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(TestRun; "Test Run No.", "Test Type", "Table Variant", "API Type")
        {
        }

        key(Performance; "Test Type", "Table Variant", "API Type", "Duration (ms)")
        {
        }
    }
}
