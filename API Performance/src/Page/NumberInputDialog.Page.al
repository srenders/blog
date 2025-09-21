page 91101 "Number Input Dialog"
{
    Caption = 'Insert Test Data';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(NumberOfRecords; NumberOfRecords)
                {
                    Caption = 'Number of Records';
                    ApplicationArea = All;
                    ToolTip = 'Enter the number of test records to insert.';

                    trigger OnValidate()
                    begin
                        if NumberOfRecords < 1 then
                            Error('Number of records must be greater than 0.');
                    end;
                }
            }
        }
    }

    var
        NumberOfRecords: Integer;

    trigger OnOpenPage()
    begin
        NumberOfRecords := 10; // Default value
    end;

    procedure GetNumberOfRecords(): Integer
    begin
        exit(NumberOfRecords);
    end;
}