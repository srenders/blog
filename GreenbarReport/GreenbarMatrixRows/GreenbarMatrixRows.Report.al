report 50141 "Greenbar Matrix Rows"
{
    Caption = 'Greenbar Matrix Rows';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    AdditionalSearchTerms = 'Greenbar Matrix Rows';

    DefaultLayout = RDLC;
    RDLCLayout = '.\GreenbarMatrixRows\GreenbarMatrixRows.rdl';
    ProcessingOnly = false;

    dataset
    {
        dataitem(Item; Item)
        {
            //DataItemTableView = WHERE(Description = FILTER(<> ''));
            PrintOnlyIfDetail = true;
            column(No_Item; Item."No.")
            {
                IncludeCaption = true;
            }
            column(Description_Item; Item.Description)
            {
                IncludeCaption = true;
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                //DataItemTableView = SORTING("Item No.") WHERE("Location Code" = FILTER(<> ''), "Item No." = FILTER(<> ''));
                column(LocationCode_ItemLedgerEntry; "Item Ledger Entry"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
                {
                    IncludeCaption = true;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ReportName = 'My Report';
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
    end;

    var
        HideDetails: Boolean;
        CompanyInformation: Record "Company Information";
}

