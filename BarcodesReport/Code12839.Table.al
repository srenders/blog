table 50150 "Code 128/39"
{

    fields
    {
        field(1; CharA; Code[10])
        {
        }
        field(2; CharB; Code[10])
        {
        }
        field(3; CharC; Code[10])
        {
        }
        field(4; Value; Code[3])
        {
        }
        field(5; Encoding; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; CharA)
        {
            Clustered = true;
        }
        key(Key2; Value)
        {
        }
    }

    fieldgroups
    {
    }
}

