page 60112 "Tennis Management Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Tennis Setup";
    Caption = 'Tennis Management Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Player Nos."; Rec."Player Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code used for player numbers.';
                }
                field("Match Nos."; Rec."Match Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code used for match numbers.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AssistedSetup)
            {
                ApplicationArea = All;
                Caption = 'Assisted Setup';
                Image = Setup;
                ToolTip = 'Launch the Tennis Management assisted setup guide';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TennisAssistedSetup: Codeunit "Tennis Assisted Setup";
                begin
                    TennisAssistedSetup.RunAssistedSetup();
                end;
            }
            action(NumberSeries)
            {
                ApplicationArea = All;
                Caption = 'Number Series';
                RunObject = Page "No. Series";
                Image = NumberSetup;
                ToolTip = 'Set up number series for tennis management';
            }
        }
        area(Navigation)
        {
            action(TennisPlayers)
            {
                ApplicationArea = All;
                Caption = 'Tennis Players';
                RunObject = Page "Tennis Player List";
                Image = Customer;
                ToolTip = 'View all tennis players';
            }
            action(TennisMatches)
            {
                ApplicationArea = All;
                Caption = 'Tennis Matches';
                RunObject = Page "Tennis Match List";
                Image = List;
                ToolTip = 'View all tennis matches';
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then Rec.Insert();
    end;
}
