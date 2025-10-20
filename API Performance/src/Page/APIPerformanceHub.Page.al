page 91118 "API Performance Hub"
{
    Caption = 'API Performance Testing Hub';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Integer;

    layout
    {
        area(content)
        {
            group(Overview)
            {
                Caption = 'Table Variants Overview';

                group(Original)
                {
                    Caption = 'Original (With Covering Indexes)';

                    field(OriginalCount; GetRecordCount(1))
                    {
                        ApplicationArea = All;
                        Caption = 'Record Count';
                        Editable = false;
                        ToolTip = 'Number of records in the original table with covering indexes.';
                        Style = Strong;
                        StyleExpr = true;
                    }

                    field(OriginalDescription; 'Optimized with covering indexes and SumIndexFields')
                    {
                        ApplicationArea = All;
                        Caption = 'Strategy';
                        Editable = false;
                        ShowCaption = false;
                        Style = Subordinate;
                        StyleExpr = true;
                    }
                }

                group(NoCovers)
                {
                    Caption = 'No Covering Indexes';

                    field(NoCoversCount; GetRecordCount(2))
                    {
                        ApplicationArea = All;
                        Caption = 'Record Count';
                        Editable = false;
                        ToolTip = 'Number of records in the table without covering indexes.';
                        Style = Strong;
                        StyleExpr = true;
                    }

                    field(NoCoversDescription; 'Regular keys only, no covering indexes')
                    {
                        ApplicationArea = All;
                        Caption = 'Strategy';
                        Editable = false;
                        ShowCaption = false;
                        Style = Subordinate;
                        StyleExpr = true;
                    }
                }

                group(Minimal)
                {
                    Caption = 'Minimal Keys';

                    field(MinimalCount; GetRecordCount(3))
                    {
                        ApplicationArea = All;
                        Caption = 'Record Count';
                        Editable = false;
                        ToolTip = 'Number of records in the table with only primary key.';
                        Style = Strong;
                        StyleExpr = true;
                    }

                    field(MinimalDescription; 'Primary key only - worst case testing')
                    {
                        ApplicationArea = All;
                        Caption = 'Strategy';
                        Editable = false;
                        ShowCaption = false;
                        Style = Subordinate;
                        StyleExpr = true;
                    }
                }

                group(AltCover)
                {
                    Caption = 'Alternative Covering';

                    field(AltCoverCount; GetRecordCount(4))
                    {
                        ApplicationArea = All;
                        Caption = 'Record Count';
                        Editable = false;
                        ToolTip = 'Number of records in the table with alternative covering strategy.';
                        Style = Strong;
                        StyleExpr = true;
                    }

                    field(AltCoverDescription; 'Multiple comprehensive covering indexes')
                    {
                        ApplicationArea = All;
                        Caption = 'Strategy';
                        Editable = false;
                        ShowCaption = false;
                        Style = Subordinate;
                        StyleExpr = true;
                    }
                }
            }

            group(QuickActions)
            {
                Caption = 'Quick Actions';
                ShowCaption = false;

                field(HelpText; 'Use the actions below to manage test data and access table variants.')
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(TestDataManagement)
            {
                Caption = 'Test Data Management';

                action(PopulateAllTables)
                {
                    Caption = 'Populate ALL Table Variants';
                    ApplicationArea = All;
                    Image = CreateMovement;
                    ToolTip = 'Insert identical test records into all 4 table variants for fair performance comparison.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

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

                action(DeleteTestData)
                {
                    Caption = 'Delete Test Data (All Tables)';
                    ApplicationArea = All;
                    Image = DeleteRow;
                    ToolTip = 'Delete all test records (TEST-*) from all 4 table variants.';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        TestDataMgt: Codeunit "Simple Transaction Test Data";
                    begin
                        TestDataMgt.DeleteAllTestDataAllTables();
                        CurrPage.Update(false);
                    end;
                }

                action(DeleteAllData)
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

            group(OpenTables)
            {
                Caption = 'Open Table Variants';

                action(OpenOriginal)
                {
                    Caption = 'Original (With Covering)';
                    ApplicationArea = All;
                    Image = Database;
                    ToolTip = 'Open the original table with covering indexes.';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        SimpleTransactionEntries: Page "Simple Transaction Entries";
                    begin
                        SimpleTransactionEntries.Run();
                    end;
                }

                action(OpenNoCovers)
                {
                    Caption = 'No Covering Indexes';
                    ApplicationArea = All;
                    Image = Database;
                    ToolTip = 'Open the table variant without covering indexes.';
                    Promoted = true;
                    PromotedCategory = Category4;

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
                    Promoted = true;
                    PromotedCategory = Category4;

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
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        SimpleTransAltCoverList: Page "Simple Trans Alt Cover List";
                    begin
                        SimpleTransAltCoverList.Run();
                    end;
                }
            }

            group(Documentation)
            {
                Caption = 'Documentation';

                action(OpenDocumentation)
                {
                    Caption = 'Performance Testing Guide';
                    ApplicationArea = All;
                    Image = Document;
                    ToolTip = 'View documentation on how to compare performance across table variants.';

                    trigger OnAction()
                    begin
                        Message('See KEY_INDEX_COMPARISON.md and QUICK_REFERENCE.md in the extension folder for:\' +
                                '- Detailed testing strategies\' +
                                '- API endpoint reference\' +
                                '- Expected performance results\' +
                                '- Best practices\' +
                                '\Search for "API Performance Hub" to access this page quickly.');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    local procedure GetRecordCount(TableVariant: Integer): Integer
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
        SimpleTransNoCovering: Record "Simple Trans No Covers";
        SimpleTransMinimalKeys: Record "Simple Trans Minimal Keys";
        SimpleTransAltCovering: Record "Simple Trans Alt Covering";
    begin
        case TableVariant of
            1:
                exit(SimpleTransactionEntry.Count);
            2:
                exit(SimpleTransNoCovering.Count);
            3:
                exit(SimpleTransMinimalKeys.Count);
            4:
                exit(SimpleTransAltCovering.Count);
        end;
    end;
}
