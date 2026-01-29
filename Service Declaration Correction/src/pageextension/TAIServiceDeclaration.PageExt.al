pageextension 60200 "TAI Service Declaration" extends "Service Declaration"
{
    actions
    {
        addlast(Processing)
        {
            action(AddLinesFromCorrections)
            {
                ApplicationArea = All;
                Caption = 'Add Lines from Corrections';
                Image = SuggestLines;
                ToolTip = 'Add Service Declaration lines from the TAI correction table for this declaration period.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AddLines: Codeunit "TAI Add Serv. Decl. Lines";
                begin
                    AddLines.AddCorrectionLines(Rec);
                    Message('Lines added from corrections.');
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
