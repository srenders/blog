enum 90110 "Power BI Refresh Status"
{
    Caption = 'Power BI Refresh Status';
    Extensible = false;

    value(0; Unknown)
    {
        Caption = 'Unknown';
    }

    value(1; Completed)
    {
        Caption = 'Completed';
    }

    value(2; Failed)
    {
        Caption = 'Failed';
    }

    value(3; "In Progress")
    {
        Caption = 'In Progress';
    }

    value(4; Disabled)
    {
        Caption = 'Disabled';
    }

    value(5; NotStarted)
    {
        Caption = 'Not Started';
    }
}