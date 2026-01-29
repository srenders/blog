page 60201 "TAI Serv. Decl. Corrections"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TAI Serv. Decl. Correction";
    Caption = 'TAI Service Declaration Corrections';
    CardPageId = "TAI Serv. Decl. Corr. Card";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Correction entry number.';
                }
                field("Value Entry No."; Rec."Value Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Value Entry to correct.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document type from Value Entry.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document number from Value Entry.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Posting date from Value Entry.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item number from Value Entry.';
                }
                field("Service Transaction Type Code"; Rec."Service Transaction Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Service Transaction Type Code to apply.';
                    ShowMandatory = true;
                }
                field("Applicable For Serv. Decl."; Rec."Applicable For Serv. Decl.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable/disable this correction.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Country/Region Code override (optional).';
                }
                field("VAT Reg. No."; Rec."VAT Reg. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Partner VAT ID.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description override.';
                }
                field("Sales Amount (LCY)"; Rec."Sales Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sales Amount in local currency.';
                }
                field("Purchase Amount (LCY)"; Rec."Purchase Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Purchase Amount in local currency.';
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'When this correction was created.';
                }
                field("Created By User"; Rec."Created By User")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who created this correction.';
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
                ToolTip = 'Suggest corrections for Value Entries missing Service Declaration fields.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Setup: Record "TAI Service Decl. Fix Setup";
                begin
                    Setup := Setup.GetSetup();
                    Page.RunModal(Page::"TAI Service Decl. Fix Setup", Setup);
                end;
            }
        }
    }
}
