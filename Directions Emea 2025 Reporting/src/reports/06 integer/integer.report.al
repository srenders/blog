report 70101 integer
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'DEMO - integer';
    //DefaultRenderingLayout = LayoutName;
    
    dataset
    {
        dataitem(HeaderText; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(0));
            column(CompanyName; CompanyInformation.Name) { }
            column(CompanyPicture; CompanyInformation.Picture) { }
            column(CompanyEmail; CompanyInformation."E-Mail") { }
            column(CompanyHomepage; CompanyInformation."Home Page") { }
        }
        dataitem(Customer;Customer)
        {
            
            column(No_Customer; "No.") { }
            column(Name_Customer; Name) { }
            column(BalanceLCY_Customer; "Balance (LCY)") { }
        }
    }
    
    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;
    var
        CompanyInformation : Record "Company Information";
}