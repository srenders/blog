page 70100 "Item Cross Sale Factbox"
{
    PageType = ListPart;
    SourceTable = "Sales Line";
    Caption = 'Items bought by others';
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Availabiliy; StrSubstNo('%1', SalesInfoPaneMgt.CalcAvailability(Rec)))
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByPeriod);
                    end;
                }
            }
        }
    }
    trigger OnFindRecord(Which: Text): Boolean
    begin
        FillTempTable();
        EXIT(FIND(Which));
    end;

    procedure FillTempTable()
    var
        ItemCrossSales: Query "Item Cross Sales";
        LineNo: Integer;
        SalesLine3: Record "Sales Line";
    begin
        //Set SalesLine3 based upon Minimum values of SalesLine:
        IF NOT
          SalesLine3.GET(
            GETRANGEMIN("Document Type"),
            GETRANGEMIN("Document No."),
            GETRANGEMIN("Line No."))
        THEN
            EXIT;

        //Filter and Run the Query:
        ItemCrossSales.SETRANGE(DocumentType, SalesLine3."Document Type");
        ItemCrossSales.SETRANGE(DocumentNo, SalesLine3."Document No.");
        ItemCrossSales.SETRANGE(ItemCrossSales.LineNo, SalesLine3."Line No.");
        ItemCrossSales.SETFILTER(ItemNumber, '<>%1', SalesLine3."No.");
        ItemCrossSales.OPEN();

        RESET();
        DELETEALL();
        LineNo := 10000;

        //Copy the Query result(s) in the temp table:
        WHILE ItemCrossSales.READ() DO BEGIN
            INIT();
            "Document Type" := SalesLine3."Document Type";
            "Document No." := SalesLine3."Document No.";
            "Line No." := LineNo;
            Type := Type::Item;
            "No." := ItemCrossSales.ItemNumber;
            Description := ItemCrossSales.Description;
            "Unit Price" := ItemCrossSales.UnitPrice;
            INSERT();
            LineNo := LineNo + 10000;
        END;

        //Close Query:
        ItemCrossSales.CLOSE();

    end;

    var
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        SalesLine: Record "Sales Line";
        LineAvail: Text;
}
