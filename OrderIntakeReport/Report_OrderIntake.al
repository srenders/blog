report 50102 OrderIntake
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'OrderIntake.rdlc';
    DefaultLayout = RDLC;
    EnableHyperlinks = true;

    dataset
    {
        dataitem(Dataset; Integer)
        {
            column(DateLoop; DateLoop)
            { }
            dataitem(SalesLineLoop; Integer)
            {
                column(No; SalesLine."No.")
                { }
                column(LocationCode; SalesLine."Location Code")
                { }
                column(ShipmentDate; SalesLine."Shipment Date")
                { }
                column(Quantity; SalesLine."Outstanding Quantity")
                { }
                column(LineAmount; SalesLine."Outstanding Amount (LCY)")
                { }
                column(CustomerNo; SalesLine."Sell-to Customer No.")
                { }
                column(CustomerName; Customer.Name)
                { }
                trigger OnPreDataItem() //SalesLineLoop
                begin
                    NoOfLoopsDetails := 0;
                    SalesLine.reset();
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetRange("Shipment Date", DateLoop);
                    SalesLine.SetFilter("Document Type", '%1|%2', SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice);

                    if SalesLine.FindSet() then
                        NoOfLoopsDetails := SalesLine.Count();

                    SetRange(Number, 1, NoOfLoopsDetails);
                end;

                trigger OnAfterGetRecord() //SalesLineLoop
                begin
                    SalesLine.Next();
                    if SalesLine."Sell-to Customer No." <> '' then
                        Customer.get(SalesLine."Sell-to Customer No.");
                end;

            }
            trigger OnPreDataItem() //Dataset
            begin
                SetRange(Number, 1, NoOfLoops);
            end;

            trigger OnAfterGetRecord() //Dataset
            begin
                DateLoop += 1;
            end;
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
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        NoOfLoops := 1;
        StartDate := 20180101D;
        EndDate := 20181231D;
    end;

    trigger OnPreReport()
    begin
        NoOfLoops := EndDate - StartDate;
        DateLoop := StartDate - 1;
    end;

    var
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        NoOfLoops: Integer;
        NoOfLoopsDetails: Integer;
        EndDate: Date;
        StartDate: Date;
        DateLoop: Date;

}