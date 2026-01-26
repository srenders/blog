page 60109 "Tennis Management Role Center"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Tennis Management';

    layout
    {
        area(RoleCenter)
        {
            part(HeadlinePart; "Tennis Management Headline")
            {
                ApplicationArea = All;
            }
            part(Activities; "Tennis Management Activities")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action(Players)
            {
                ApplicationArea = All;
                Caption = 'Tennis Players';
                RunObject = page "Tennis Player List";
                ToolTip = 'View and manage tennis players';
            }
            action(Matches)
            {
                ApplicationArea = All;
                Caption = 'Tennis Matches';
                RunObject = page "Tennis Match List";
                ToolTip = 'View and manage tennis matches';
            }
        }
        area(Sections)
        {
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;

                action(Setup)
                {
                    ApplicationArea = All;
                    Caption = 'Tennis Management Setup';
                    RunObject = page "Tennis Management Setup";
                    ToolTip = 'Configure the tennis management system';
                }
            }
        }
        area(Processing)
        {
            action(ScheduleMatch)
            {
                ApplicationArea = All;
                Caption = 'Schedule Match';
                Image = NewDocument;
                RunObject = page "Tennis Match Card";
                RunPageMode = Create;
                ToolTip = 'Create a new tennis match';
            }
            action(RegisterPlayer)
            {
                ApplicationArea = All;
                Caption = 'Register Player';
                Image = NewCustomer;
                RunObject = page "Tennis Player Card";
                RunPageMode = Create;
                ToolTip = 'Register a new tennis player';
            }

            group(DataManagement)
            {
                Caption = 'Data Management';
                Image = DataEntry;

                action(ExportPlayers)
                {
                    ApplicationArea = All;
                    Caption = 'Export / Import Tennis Players';
                    Image = ExportFile;
                    ToolTip = 'Export / Import tennis players data to/from an XML file';
                    RunObject = XMLport "Tennis Player";
                }

            }
        }
        area(Reporting)
        {
            action(PlayersAndMatches)
            {
                ApplicationArea = All;
                Caption = 'Players and Matches Report';
                Image = Report;
                RunObject = report "Tennis Players and Matches";
                ToolTip = 'View a report of tennis players and their scheduled matches';
            }
        }
    }
}
