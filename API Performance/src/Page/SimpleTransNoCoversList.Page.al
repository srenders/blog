page 91115 "Simple Trans No Covers List"
{
    Caption = 'Simple Transaction Entries - No Covering Indexes';
    PageType = List;
    SourceTable = "Simple Trans No Covers";
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
                        TestDataMgt.InsertTestRecordsNoCovers(NumberOfRecords);
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
                        TestDataMgt.TruncateTestRecordsNoCovers();
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
                        TestDataMgt.DeleteAllRecordsNoCovers();
                        CurrPage.Update(false);
                        Message('All records have been deleted successfully.');
                    end;
                end;
            }
        }
    }
}
