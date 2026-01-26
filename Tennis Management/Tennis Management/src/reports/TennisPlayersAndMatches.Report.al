report 60124 "Tennis Players and Matches"
{
    Caption = 'Tennis Players and Matches';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = TennisPlayersMatchesRDL;


    dataset
    {
        dataitem(TennisPlayer; "Tennis Player")
        {
            RequestFilterFields = "No.", Name;
            PrintOnlyIfDetail = true;

            column(No_TennisPlayer; "No.")
            {
                IncludeCaption = true;
            }
            column(Name_TennisPlayer; Name)
            {
                IncludeCaption = true;
            }
            column(DateOfBirth_TennisPlayer; "Date of Birth")
            {
                IncludeCaption = true;
            }
            column(PhoneNo_TennisPlayer; "Phone No.")
            {
                IncludeCaption = true;
            }
            column(Email_TennisPlayer; "E-Mail")
            {
                IncludeCaption = true;
            }
            column(TotalMatches_TennisPlayer; "Total Matches")
            {
                IncludeCaption = true;
            }
            column(MatchesWon_TennisPlayer; "Matches Won")
            {
                IncludeCaption = true;
            }
            column(MatchesLost_TennisPlayer; "Matches Lost")
            {
                IncludeCaption = true;
            }

            dataitem(PlayerMatchLine; "Tennis Match Line")
            {
                DataItemLink = "Player No." = field("No.");
                DataItemTableView = sorting("Match No.", "Line No.");
                RequestFilterFields = "Match No.";

                column(MatchNo_PlayerMatchLine; "Match No.")
                {
                    IncludeCaption = true;
                }
                column(LineNo_PlayerMatchLine; "Line No.")
                {
                    IncludeCaption = true;
                }
                column(Team_PlayerMatchLine; Team)
                {
                    IncludeCaption = true;
                }
                column(MatchDate; this.MatchDate) { }
                column(CourtNo; this.CourtNo) { }
                column(MatchStatus; Format(this.MatchStatus)) { }
                column(Opponent; this.OpponentName) { }

                trigger OnAfterGetRecord()
                begin
                    this.GetMatchDetails();
                    this.FindOpponent();
                end;

                trigger OnPreDataItem()
                begin
                    if ShowOnlyScheduled then
                        PlayerMatchLine.SetRange("Match Status", MatchStatus::Open);

                    if ShowFutureOnly then begin
                        TennisMatch.Reset();
                        TennisMatch.SetFilter("Match Date", '>=%1', WorkDate());
                        if TennisMatch.FindSet() then begin
                            MatchFilter := '';
                            repeat
                                if MatchFilter <> '' then
                                    MatchFilter += '|';
                                MatchFilter += TennisMatch."No.";
                            until TennisMatch.Next() = 0;

                            if MatchFilter <> '' then
                                PlayerMatchLine.SetFilter("Match No.", MatchFilter)
                            else
                                PlayerMatchLine.SetRange("Match No.", '');
                        end else
                            PlayerMatchLine.SetRange("Match No.", '');
                    end;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowFutureOnly; ShowFutureOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Future Matches Only';
                        ToolTip = 'Specifies to show only matches that are scheduled for today or later.';
                    }
                    field(ShowOnlyScheduled; ShowOnlyScheduled)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Only Scheduled Matches';
                        ToolTip = 'Specifies to show only matches with status Scheduled.';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(TennisPlayersMatchesExcel)
        {
            Type = Excel;
            LayoutFile = './src/reports/TennisPlayersMatches.xlsx';
            Caption = 'Tennis Players and Matches';
        }
        layout(TennisPlayersMatchesRDL)
        {
            Type = RDLC;
            LayoutFile = './src/reports/TennisPlayersMatches.rdl';
            Caption = 'Tennis Players and Matches';
        }
        layout(TennisPlayersMatchesWprd)
        {
            Type = Word;
            LayoutFile = './src/reports/TennisPlayersMatches.docx';
            Caption = 'Tennis Players and Matches';
        }
    }

    labels
    {
        ReportTitle = 'Tennis Players and Scheduled Matches';
        PlayerNoLbl = 'Player No.';
        PlayerNameLbl = 'Name';
        MatchNoLbl = 'Match No.';
        MatchDateLbl = 'Match Date';
        CourtNoLbl = 'Court No.';
        StatusLbl = 'Status';
        OpponentLbl = 'Opponent';
        TeamLbl = 'Team';
        NoMatchesLbl = 'No matches scheduled for this player.';
    }

    var
        TennisMatch: Record "Tennis Match";
        OpponentLine: Record "Tennis Match Line";
        ShowFutureOnly: Boolean;
        ShowOnlyScheduled: Boolean;
        MatchStatus: Enum "Tennis Match Status";
        MatchDate: Date;
        CourtNo: Text[20];
        OpponentName: Text[100];
        MatchFilter: Text;

    local procedure GetMatchDetails()
    begin
        if TennisMatch.Get(PlayerMatchLine."Match No.") then begin
            MatchDate := TennisMatch."Match Date";
            CourtNo := TennisMatch."Court No.";
            MatchStatus := TennisMatch.Status;
        end else begin
            MatchDate := 0D;
            CourtNo := '';
            Clear(MatchStatus);
        end;
    end;

    local procedure FindOpponent()
    var
        TennisPlayerRec: Record "Tennis Player";
    begin
        OpponentName := '';
        OpponentLine.Reset();
        OpponentLine.SetRange("Match No.", PlayerMatchLine."Match No.");
        OpponentLine.SetFilter("Player No.", '<>%1', PlayerMatchLine."Player No.");

        if OpponentLine.FindFirst() then
            if TennisPlayerRec.Get(OpponentLine."Player No.") then
                OpponentName := TennisPlayerRec.Name;
    end;

    trigger OnPreRendering(var RenderingPayload: JsonObject)
    var
        AttachmentsArray: JsonArray;
        AttachmentObj: JsonObject;
        StatsSummaryPdfFile: Text;
        PlayerStatsXmlFile: Text;
    begin
        // Add version information to the rendering payload
        RenderingPayload.Add('version', '1.0.0.0');

        // Set save format for e-invoicing compliance (optional - can use 'Default' for standard PDF)
        RenderingPayload.Add('saveformat', 'Default');

        // Example 1: Attach an XML file with player statistics data
        PlayerStatsXmlFile := CreatePlayerStatsXmlFile();
        if PlayerStatsXmlFile <> '' then begin
            AttachmentObj.Add('name', 'PlayerStatistics.xml');
            AttachmentObj.Add('filename', PlayerStatsXmlFile);
            AttachmentObj.Add('description', 'Detailed player statistics in XML format');
            AttachmentObj.Add('relationship', 'Data'); // 'Data', 'Source', 'Alternative', 'Supplement', or 'Unspecified'
            AttachmentObj.Add('mimetype', 'text/xml');
            AttachmentsArray.Add(AttachmentObj);
        end;

        // Example 2: Attach a summary statistics report as PDF
        // Note: This generates a PDF from another report and attaches it
        StatsSummaryPdfFile := CreatePlayerStatisticsPdf();
        if StatsSummaryPdfFile <> '' then begin
            Clear(AttachmentObj);
            AttachmentObj.Add('name', 'PlayerStatisticsSummary.pdf');
            AttachmentObj.Add('filename', StatsSummaryPdfFile);
            AttachmentObj.Add('description', 'Player statistics summary report');
            AttachmentObj.Add('relationship', 'Supplement');
            AttachmentObj.Add('mimetype', 'application/pdf');
            AttachmentsArray.Add(AttachmentObj);
        end;

        // Add all attachments to the rendering payload
        if AttachmentsArray.Count > 0 then
            RenderingPayload.Add('attachments', AttachmentsArray);

        // Example 3: Append an additional PDF document to the end of the report
        // This could be terms & conditions, additional reports, etc.
        // Note: AdditionalDocuments appends PDFs, while attachments embeds them as file attachments
        // To enable, uncomment these lines:
        // var AdditionalDocumentsArray: JsonArray;
        // StatsSummaryPdfFile := CreatePlayerStatisticsPdf();
        // if StatsSummaryPdfFile <> '' then begin
        //     AdditionalDocumentsArray.Add(StatsSummaryPdfFile);
        //     RenderingPayload.Add('additionalDocuments', AdditionalDocumentsArray);
        // end;

        // Example 4: Add password protection (optional)
        // To enable, uncomment this line:
        // AddPasswordProtection(RenderingPayload);
    end;

    local procedure CreatePlayerStatsXmlFile() FilePath: Text
    var
        PlayerRec: Record "Tennis Player";
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OutStream: OutStream;
    begin
        // Create a temporary XML file with player statistics using cloud-compatible APIs
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);

        // Write XML content
        OutStream.WriteText('<?xml version="1.0" encoding="utf-8" standalone="yes"?>');
        OutStream.WriteText('<PlayerStatistics>');

        // Get the filtered players from the report
        TennisPlayer.CopyFilters(PlayerRec);
        if PlayerRec.FindSet() then
            repeat
                OutStream.WriteText('<Player>');
                OutStream.WriteText('<No>' + PlayerRec."No." + '</No>');
                OutStream.WriteText('<Name>' + PlayerRec.Name + '</Name>');
                OutStream.WriteText('<TotalMatches>' + Format(PlayerRec."Total Matches") + '</TotalMatches>');
                OutStream.WriteText('<MatchesWon>' + Format(PlayerRec."Matches Won") + '</MatchesWon>');
                OutStream.WriteText('<MatchesLost>' + Format(PlayerRec."Matches Lost") + '</MatchesLost>');
                if PlayerRec."Total Matches" > 0 then
                    OutStream.WriteText('<WinPercentage>' + Format(Round(PlayerRec."Matches Won" / PlayerRec."Total Matches" * 100, 0.01)) + '</WinPercentage>')
                else
                    OutStream.WriteText('<WinPercentage>0</WinPercentage>');
                OutStream.WriteText('</Player>');
            until PlayerRec.Next() = 0;

        OutStream.WriteText('</PlayerStatistics>');

        // Export to temporary file
        FilePath := FileManagement.BLOBExportWithEncoding(TempBlob, 'PlayerStatistics.xml', true, TextEncoding::UTF8);
    end;

    local procedure CreatePlayerStatisticsPdf(): Text
    begin
        // Create a PDF file with player statistics
        // This is a simplified example - in a real scenario, you would:
        // 1. Run another report with player statistics using Report.SaveAs()
        // 2. Save it to a TempBlob
        // 3. Export to temporary file and return the file path

        // Example of how to generate a PDF from another report:
        // var
        //     TempBlob: Codeunit "Temp Blob";
        //     FileManagement: Codeunit "File Management";
        //     InStr: InStream;
        //     OutStr: OutStream;
        //     FilePath: Text;
        // begin
        //     Clear(TempBlob);
        //     TempBlob.CreateOutStream(OutStr);
        //     Report.SaveAs(Report::"Tennis Players and Matches", '', ReportFormat::Pdf, OutStr);
        //     TempBlob.CreateInStream(InStr);
        //     exit(FileManagement.BLOBExport(TempBlob, 'PlayerStatsSummary.pdf', true));
        // end;

        // For this demonstration, we skip the PDF attachment
        // Remove the exit statement below and implement the code above to enable PDF attachment
        exit('');
    end;

    // Example of password protection - uncomment and call from OnPreRendering to enable
    // local procedure AddPasswordProtection(var RenderingPayload: JsonObject)
    // var
    //     ProtectionObj: JsonObject;
    // begin
    //     // Add password protection to the PDF
    //     // User password: required to open the document
    //     // Admin password: gives full access (if empty, uses user password)
    //
    //     ProtectionObj.Add('user', 'Tennis2025!');
    //     ProtectionObj.Add('admin', 'TennisAdmin2025!');
    //
    //     RenderingPayload.Add('protection', ProtectionObj);
    // end;
}
