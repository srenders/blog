page 60113 "Tennis Setup Wizard"
{
    PageType = NavigatePage;
    Caption = 'Tennis Management Setup';
    SourceTable = "Tennis Setup";

    layout
    {
        area(Content)
        {
            group(MediaStandard)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible;

                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(WelcomePage)
            {
                Caption = '';
                Visible = WelcomePageVisible;

                group(WelcomeGroup)
                {
                    Caption = '';
                    InstructionalText = 'This guide will help you set up the Tennis Management module.';

                    group(WelcomeGroupDetails)
                    {
                        Caption = '';
                        InstructionalText = 'You will set up the number series for players and matches, which is essential for the Tennis Management functionality.';
                    }
                }
            }

            group(NumberSeriesPage)
            {
                Caption = '';
                Visible = NumberSeriesPageVisible;

                group(NumberSeriesGroup)
                {
                    Caption = 'Number Series';
                    InstructionalText = 'Set up the number series for Tennis Players and Matches.';

                    field("Player Nos."; Rec."Player Nos.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number series code used for player numbers.';
                        TableRelation = "No. Series";
                    }

                    field("Match Nos."; Rec."Match Nos.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number series code used for match numbers.';
                        TableRelation = "No. Series";
                    }
                }
            }

            group(FinishPage)
            {
                Caption = '';
                Visible = FinishPageVisible;

                group(FinishGroup)
                {
                    Caption = '';
                    InstructionalText = 'You have successfully set up the Tennis Management module. Click Finish to save your changes.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Back)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }

            action(Next)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }

            action(Finish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    FinishAction();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Insert();

        Step := Step::Welcome;
        EnableControls();
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesStandard: Record "Media Resources";
        Step: Option Welcome,NumberSeries,Finish;
        TopBannerVisible: Boolean;
        WelcomePageVisible: Boolean;
        NumberSeriesPageVisible: Boolean;
        FinishPageVisible: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        FinishActionEnabled: Boolean;

    local procedure LoadTopBanners()
    begin
        TopBannerVisible := false;

        if not MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) then
            exit;

        if not MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") then
            exit;

        TopBannerVisible := MediaResourcesStandard."Media Reference".HasValue();
    end;

    local procedure EnableControls()
    begin
        WelcomePageVisible := Step = Step::Welcome;
        NumberSeriesPageVisible := Step = Step::NumberSeries;
        FinishPageVisible := Step = Step::Finish;

        BackActionEnabled := Step > Step::Welcome;
        NextActionEnabled := Step < Step::Finish;
        FinishActionEnabled := Step = Step::Finish;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Step -= 1
        else
            Step += 1;

        EnableControls();
    end;

    local procedure FinishAction()
    begin
        Rec.Modify(true);
        CurrPage.Close();
    end;
}
