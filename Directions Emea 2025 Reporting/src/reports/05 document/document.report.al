report 70100 Document
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLayout;
    Caption = 'DEMO - Document';
    WordMergeDataItem = Header;
    //https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-wordmergedataitem-property
    
    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Bill-to Name";
            column(BilltoCustomerNo_Header; "Bill-to Customer No.") { }
            column(BilltoCustomerNo_HeaderCptn; FieldCaption("Bill-to Customer No.")) { }
            column(No_Header; "No.") { }
            column(No_HeaderCptn; FieldCaption("No.")) { }
            column(ReportTitleLbl; ReportTitleLbl) { }
            dataitem(Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(Type_Line; "Type") { }
                column(No_Line; "No.") { }
                column(Description_Line; Description) { }
                column(Quantity_Line; Quantity) { }
            }
            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault(Header."Language Code");
            end;
        }
        dataitem(CompanyInfo; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(0));
            column(CompanyName; CompanyInformation.Name) { }
            column(CompanyPicture; CompanyInformation.Picture) { }
        }
    }

    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './src/reports/05 Document/Document.rdlc';
            Caption = '05 Document RDLC';
            Summary = 'Shows 05 Document';
        }
        layout(WORDLayout)
        {
            Type = Word;
            LayoutFile = './src/reports/05 Document/Document.docx';
            Caption = '05 Document Word';
            Summary = 'Shows 05 Document';
        }
    }
    trigger OnPreReport()
    begin
        if Header.GetFilters = '' then
            Error(NoFilterSetErr);

        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        LanguageMgt: Codeunit Language;
        ReportTitleLbl: Label 'Sales Invoice Report';
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidently printing all documents.';
}