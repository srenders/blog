report 60100 TopXCustomers
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    AdditionalSearchTerms = 'Report TopXCustomers';
    DefaultLayout = RDLC;

    RDLCLayout = 'TopXCustomers.rdl';
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(number);
            column(customerNo; customerNo) { }
            column(customerName; customerName) { }
            column(customerBalance; customerBalance) { }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, TopX);
                TopXCustomers.TopNumberOfRows(TopX);
                TopXCustomers.open();
            end;

            trigger OnAfterGetRecord()
            begin
                if TopXCustomers.Read() then begin
                    customerNo := TopXCustomers.No;
                    customerName := TopXCustomers.Name;
                    customerBalance := TopXCustomers.BalanceLCY;
                end
                else begin
                    CurrReport.Skip();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(TopX; TopX)
                    {
                        Caption = 'TopX?';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        TopX := 10;
    end;

    var
        TopXCustomers: Query TopXCustomers;
        TopX: Integer;
        customerNo: Code[20];
        customerName: Text;
        customerBalance: Decimal;
}
