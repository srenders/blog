page 60202 "TAI Serv. Decl. Corr. Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "TAI Serv. Decl. Correction";
    Caption = 'TAI Service Declaration Correction Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Correction entry number.';
                }
                field("Value Entry No."; Rec."Value Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Value Entry to correct.';
                    ShowMandatory = true;
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
                    ToolTip = 'Country/Region Code override (leave blank to use original).';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency Code for the transaction.';
                }
                field("VAT Reg. No."; Rec."VAT Reg. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Partner VAT ID.';
                }
                field("Item Charge No."; Rec."Item Charge No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item Charge Number if applicable.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description override (leave blank to use original).';
                }
                field("Sales Amount"; Rec."Sales Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sales Amount in original currency.';
                }
                field("Sales Amount (LCY)"; Rec."Sales Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sales Amount in local currency (leave 0 to use Value Entry amount).';
                }
                field("Purchase Amount"; Rec."Purchase Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Purchase Amount in original currency.';
                }
                field("Purchase Amount (LCY)"; Rec."Purchase Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Purchase Amount in local currency (leave 0 to use Value Entry amount).';
                }
            }

            group(ValueEntryInfo)
            {
                Caption = 'Value Entry Information';
                Editable = false;

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
            }

            group(Tracking)
            {
                Caption = 'Tracking';
                Editable = false;

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
}
