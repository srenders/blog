page 70124 "Report PDF Attachment Factbox"
{
    PageType = ListPart;
    SourceTable = "Document Attachment";
    Caption = 'PDF Attachments';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Attachments)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The name of the attached file';

                    trigger OnDrillDown()
                    begin
                        Rec.Export(true);
                    end;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    ToolTip = 'The file extension';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'When the file was attached';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(View)
            {
                ApplicationArea = All;
                Caption = 'View';
                Image = View;
                ToolTip = 'View the PDF in the browser';

                trigger OnAction()
                var
                    TenantMedia: Record "Tenant Media";
                    InStr: InStream;
                begin
                    if TenantMedia.Get(Rec."Document Reference ID".MediaId) then begin
                        TenantMedia.Content.CreateInStream(InStr);
                        File.ViewFromStream(InStr, Rec."File Name");
                    end;
                end;
            }
        }
    }

    procedure SetFilterByReportID(ReportID: Integer)
    begin
        Rec.SetRange("Table ID", Database::"Report PDF Storage");
        Rec.SetRange("No.", Format(ReportID));
        CurrPage.Update(false);
    end;
}
