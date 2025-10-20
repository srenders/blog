page 91116 "Simple Trans Minimal List"
{
    Caption = 'Simple Transaction Entries - Minimal Keys';
    PageType = List;
    SourceTable = "Simple Trans Minimal Keys";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description.';
                }

                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount in local currency.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(InsertTestData)
            {
                Caption = 'Insert Test Data';
                ApplicationArea = All;
                Image = CreateDocument;
                ToolTip = 'Insert test records into this table.';

                trigger OnAction()
                var
                    TestDataMgt: Codeunit "Simple Transaction Test Data";
                    NumberInputDialog: Page "Number Input Dialog";
                    NumberOfRecords: Integer;
                begin
                    if NumberInputDialog.RunModal() = Action::OK then begin
                        NumberOfRecords := NumberInputDialog.GetNumberOfRecords();
                        TestDataMgt.InsertTestRecordsMinimal(NumberOfRecords);
                        CurrPage.Update(false);
                        Message('%1 test records have been inserted successfully.', NumberOfRecords);
                    end;
                end;
            }

            action(TruncateTestData)
            {
                Caption = 'Delete Test Data';
                ApplicationArea = All;
                Image = DeleteRow;
                ToolTip = 'Delete only test records (Document No. starting with TEST-) from the table.';

                trigger OnAction()
                var
                    TestDataMgt: Codeunit "Simple Transaction Test Data";
                begin
                    if Confirm('Are you sure you want to delete all test records (TEST-*) from this table?', false) then begin
                        TestDataMgt.TruncateTestRecordsMinimal();
                        CurrPage.Update(false);
                        Message('All test records have been deleted successfully.');
                    end;
                end;
            }

            action(DeleteAllData)
            {
                Caption = 'Delete All Data';
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Delete all records from this table.';

                trigger OnAction()
                var
                    TestDataMgt: Codeunit "Simple Transaction Test Data";
                begin
                    if Confirm('Are you sure you want to delete all records from this table?', false) then begin
                        TestDataMgt.DeleteAllRecordsMinimal();
                        CurrPage.Update(false);
                        Message('All records have been deleted successfully.');
                    end;
                end;
            }
        }
    }
}
