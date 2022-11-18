report 50101 Finance
{
    Caption = 'Finance';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = Finance1;

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            column(AccountCategory; "Account Category")
            { }
            column(AccountSubcategory; "Account Subcategory Descript.")
            { }
            column(AccountType; "Account Type")
            { }
            column(AccountNo; "No.")
            { }
            column(AccountName; Name)
            { }
            column(AccountNameNo; Name + ' (' + "No." + ')')
            { }
            dataitem(GLEntry; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = field("No.");
                DataItemTableView = sorting("G/L Account No.");
                column(Amount; Amount)
                { }
                column(Year; System.Date2DMY("Posting Date", 3))
                { }
                column(Month; System.Date2DMY("Posting Date", 2))
                { }
                column(PostingDate; "Posting Date")
                { }
            }
        }
    }

    rendering
    {
        layout(Finance1)
        {
            Type = Excel;
            LayoutFile = './src/reports/Finance/Finance1.xlsx';
            Summary = 'Finance layout, pivot.';
        }
        layout(Finance2)
        {
            Type = Excel;
            LayoutFile = './src/reports/Finance/Finance2.xlsx';
            Summary = 'Finance layout, pivot.';
        }
    }
}