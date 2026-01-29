page 60200 "TAI Service Decl. Fix Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "TAI Service Decl. Fix Setup";
    Caption = 'TAI Service Declaration Correction Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Instructions)
            {
                Caption = 'Instructions';
                InstructionalText = 'Create correction entries for Value Entries missing Service Declaration fields. Use "Add Lines from Corrections" action on Service Declaration page to apply them.';
            }

            group(General)
            {
                Caption = 'Configuration';

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Starting date for filtering Value Entries.';
                    ShowMandatory = true;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ending date for filtering Value Entries.';
                    ShowMandatory = true;
                }
                field("Default Serv. Trans. Type Code"; Rec."Default Serv. Trans. Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default Service Transaction Type Code applied to corrections.';
                    ShowMandatory = true;
                }
                field("Filter Method"; Rec."Filter Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'All Entries: no filter | Item Type Service: Type=Service only | VAT EU Service: not supported.';
                }
                field("Limit to EU Countries"; Rec."Limit to EU Countries")
                {
                    ApplicationArea = All;
                    ToolTip = 'Only include entries with EU Country/Region Codes.';
                }
            }

            group(LastRun)
            {
                Caption = 'Last Run';

                field("Last Run Date"; Rec."Last Run Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'When corrections were last suggested.';
                }
                field("Lines Created"; Rec."Lines Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Correction entries created in last run.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SuggestCorrections)
            {
                ApplicationArea = All;
                Caption = 'Suggest Corrections';
                Image = SuggestLines;
                ToolTip = 'Create correction entries for Value Entries missing Service Declaration fields.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SuggestCorr: Codeunit "TAI Suggest Serv. Decl. Corr.";
                begin
                    CurrPage.SaveRecord();
                    SuggestCorr.Run(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ViewCorrections)
            {
                ApplicationArea = All;
                Caption = 'View Corrections';
                Image = List;
                ToolTip = 'Open the list of correction entries.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CorrectionPage: Page "TAI Serv. Decl. Corrections";
                begin
                    CorrectionPage.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec := Rec.GetSetup();
    end;
}
