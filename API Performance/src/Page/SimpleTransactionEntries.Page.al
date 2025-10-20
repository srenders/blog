page 91100 "Simple Transaction Entries"
{
    Caption = 'Simple Transaction Entries';
    PageType = List;
    SourceTable = "Simple Transaction Entry";
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
                ToolTip = 'Insert test records into the table.';

                trigger OnAction()
                var
                    TestDataMgt: Codeunit "Simple Transaction Test Data";
                    NumberInputDialog: Page "Number Input Dialog";
                    NumberOfRecords: Integer;
                begin
                    if NumberInputDialog.RunModal() = Action::OK then begin
                        NumberOfRecords := NumberInputDialog.GetNumberOfRecords();
                        TestDataMgt.InsertTestRecords(NumberOfRecords);
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
                    if Confirm('Are you sure you want to delete all test records (TEST-*) from the Simple Transaction Entry table?', false) then begin
                        TestDataMgt.TruncateTestRecords();
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
                ToolTip = 'Delete all records from the Simple Transaction Entry table.';

                trigger OnAction()
                var
                    TestDataMgt: Codeunit "Simple Transaction Test Data";
                begin
                    if Confirm('Are you sure you want to delete all records from the Simple Transaction Entry table?', false) then begin
                        TestDataMgt.DeleteAllRecords();
                        CurrPage.Update(false);
                        Message('All records have been deleted successfully.');
                    end;
                end;
            }
        }

        area(navigation)
        {
            group(BulkOperations)
            {
                Caption = 'Bulk Operations (All Tables)';

                action(InsertTestDataAllTables)
                {
                    Caption = 'Populate ALL Table Variants';
                    ApplicationArea = All;
                    Image = CreateMovement;
                    ToolTip = 'Insert identical test records into all 4 table variants for performance comparison.';

                    trigger OnAction()
                    var
                        TestDataMgt: Codeunit "Simple Transaction Test Data";
                        NumberInputDialog: Page "Number Input Dialog";
                        NumberOfRecords: Integer;
                    begin
                        if NumberInputDialog.RunModal() = Action::OK then begin
                            NumberOfRecords := NumberInputDialog.GetNumberOfRecords();
                            TestDataMgt.InsertTestRecordsAllTables(NumberOfRecords);
                            CurrPage.Update(false);
                        end;
                    end;
                }

                action(DeleteTestDataAllTables)
                {
                    Caption = 'Delete Test Data (All Tables)';
                    ApplicationArea = All;
                    Image = DeleteRow;
                    ToolTip = 'Delete all test records (TEST-*) from all 4 table variants.';

                    trigger OnAction()
                    var
                        TestDataMgt: Codeunit "Simple Transaction Test Data";
                    begin
                        TestDataMgt.DeleteAllTestDataAllTables();
                        CurrPage.Update(false);
                    end;
                }

                action(DeleteAllDataAllTables)
                {
                    Caption = 'Delete ALL Data (All Tables)';
                    ApplicationArea = All;
                    Image = Delete;
                    ToolTip = 'Delete all records from all 4 table variants. WARNING: This cannot be undone!';

                    trigger OnAction()
                    var
                        TestDataMgt: Codeunit "Simple Transaction Test Data";
                    begin
                        TestDataMgt.DeleteAllRecordsAllTables();
                        CurrPage.Update(false);
                    end;
                }
            }

            group(OtherVariants)
            {
                Caption = 'Other Table Variants';

                action(OpenNoCovers)
                {
                    Caption = 'No Covering Indexes';
                    ApplicationArea = All;
                    Image = Database;
                    ToolTip = 'Open the table variant without covering indexes.';

                    trigger OnAction()
                    var
                        SimpleTransNoCoversList: Page "Simple Trans No Covers List";
                    begin
                        SimpleTransNoCoversList.Run();
                    end;
                }

                action(OpenMinimal)
                {
                    Caption = 'Minimal Keys';
                    ApplicationArea = All;
                    Image = Database;
                    ToolTip = 'Open the table variant with only primary key.';

                    trigger OnAction()
                    var
                        SimpleTransMinimalList: Page "Simple Trans Minimal List";
                    begin
                        SimpleTransMinimalList.Run();
                    end;
                }

                action(OpenAltCover)
                {
                    Caption = 'Alternative Covering';
                    ApplicationArea = All;
                    Image = Database;
                    ToolTip = 'Open the table variant with alternative covering strategy.';

                    trigger OnAction()
                    var
                        SimpleTransAltCoverList: Page "Simple Trans Alt Cover List";
                    begin
                        SimpleTransAltCoverList.Run();
                    end;
                }
            }
        }
    }
}