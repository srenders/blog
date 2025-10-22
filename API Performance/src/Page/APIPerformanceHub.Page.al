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

            group(APIsAvailable)
            {
                Caption = 'Available APIs (12 Total)';

                group(PageAPIs)
                {
                    Caption = 'Page APIs (4)';

                    field(PageAPI1; 'simpleTransactionEntriesPages')
                    {
                        ApplicationArea = All;
                        Caption = 'Original';
                        Editable = false;
                        ToolTip = 'Page API for Original table with covering indexes';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(PageAPI2; 'simpleTransactionNoCovers')
                    {
                        ApplicationArea = All;
                        Caption = 'No Covering';
                        Editable = false;
                        ToolTip = 'Page API for table without covering indexes';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(PageAPI3; 'simpleTransactionMinimal')
                    {
                        ApplicationArea = All;
                        Caption = 'Minimal Keys';
                        Editable = false;
                        ToolTip = 'Page API for table with minimal keys';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(PageAPI4; 'simpleTransactionAltCover')
                    {
                        ApplicationArea = All;
                        Caption = 'Alt Covering';
                        Editable = false;
                        ToolTip = 'Page API for table with alternative covering';
                        Style = Subordinate;
                        StyleExpr = true;
                    }
                }

                group(QueryAPIs)
                {
                    Caption = 'Query APIs (4)';

                    field(QueryAPI1; 'simpleTransactionEntryQuerys')
                    {
                        ApplicationArea = All;
                        Caption = 'Original';
                        Editable = false;
                        ToolTip = 'Query API for Original table';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(QueryAPI2; 'simpleTransactionNoCoversQuery')
                    {
                        ApplicationArea = All;
                        Caption = 'No Covering';
                        Editable = false;
                        ToolTip = 'Query API for No Covering table';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(QueryAPI3; 'simpleTransactionMinimalQuery')
                    {
                        ApplicationArea = All;
                        Caption = 'Minimal Keys';
                        Editable = false;
                        ToolTip = 'Query API for Minimal Keys table';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(QueryAPI4; 'simpleTransactionAltCoverQuery')
                    {
                        ApplicationArea = All;
                        Caption = 'Alt Covering';
                        Editable = false;
                        ToolTip = 'Query API for Alternative Covering table';
                        Style = Subordinate;
                        StyleExpr = true;
                    }
                }

                group(AggrQueryAPIs)
                {
                    Caption = 'Aggregate Query APIs (4)';

                    field(AggrAPI1; 'simpleTransactionEntryQueryAggrs')
                    {
                        ApplicationArea = All;
                        Caption = 'Original';
                        Editable = false;
                        ToolTip = 'Aggregate Query API for Original table';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(AggrAPI2; 'simpleTransactionNoCoversAggr')
                    {
                        ApplicationArea = All;
                        Caption = 'No Covering';
                        Editable = false;
                        ToolTip = 'Aggregate Query API for No Covering table';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(AggrAPI3; 'simpleTransactionMinimalAggr')
                    {
                        ApplicationArea = All;
                        Caption = 'Minimal Keys';
                        Editable = false;
                        ToolTip = 'Aggregate Query API for Minimal Keys table';
                        Style = Subordinate;
                        StyleExpr = true;
                    }

                    field(AggrAPI4; 'simpleTransactionAltCoverAggr')
                    {
                        ApplicationArea = All;
                        Caption = 'Alt Covering';
                        Editable = false;
                        ToolTip = 'Aggregate Query API for Alternative Covering table';
                        Style = Subordinate;
                        StyleExpr = true;
                    }
                }
            }

            group(BestPerforming)
            {
                Caption = 'Best Performing API';

                field(BestAPIName; GetBestPerformingAPI())
                {
                    ApplicationArea = All;
                    Caption = 'Fastest API';
                    Editable = false;
                    ToolTip = 'The API with the lowest duration from all test results';
                    Style = Favorable;
                    StyleExpr = true;
                }

                field(BestAPIDuration; GetBestPerformingDuration())
                {
                    ApplicationArea = All;
                    Caption = 'Duration (ms)';
                    Editable = false;
                    ToolTip = 'Duration in milliseconds of the fastest test';
                    Style = Strong;
                    StyleExpr = true;
                }

                field(BestAPINote; 'Run performance tests to see results')
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    Style = Subordinate;
                    StyleExpr = true;
                }
            }

            group(QuickActions)
            {
                Caption = 'Quick Start';
                ShowCaption = false;

                field(HelpText; '1) Populate test data  2) Run performance tests  3) View results')
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
        area(Promoted)
        {
            group(Category_Testing)
            {
                Caption = '1. Testing';

                actionref(PopulateAllTables_Promoted; PopulateAllTables) { }
                actionref(RunPerformanceTests_Promoted; RunPerformanceTests) { }
                actionref(ViewTestResults_Promoted; ViewTestResults) { }
            }

            group(Category_Analysis)
            {
                Caption = '2. Analysis';

                actionref(ShowBestAPIs_Promoted; ShowBestAPIs) { }
                actionref(ShowStatistics_Promoted; ShowStatistics) { }
                actionref(CompareLastRuns_Promoted; CompareLastRuns) { }
            }

            group(Category_Data)
            {
                Caption = '3. Data Management';

                actionref(DeleteTestData_Promoted; DeleteTestData) { }
                actionref(DeleteAllData_Promoted; DeleteAllData) { }
            }

            group(Category_Navigate)
            {
                Caption = '4. Navigate';

                actionref(OpenOriginal_Promoted; OpenOriginal) { }
                actionref(OpenNoCovers_Promoted; OpenNoCovers) { }
                actionref(OpenMinimal_Promoted; OpenMinimal) { }
                actionref(OpenAltCover_Promoted; OpenAltCover) { }
            }
        }

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

            group(PerformanceTests)
            {
                Caption = 'Performance Testing';

                action(RunPerformanceTests)
                {
                    Caption = 'Run Performance Tests';
                    ApplicationArea = All;
                    Image = TestDatabase;
                    ToolTip = 'Test all 12 APIs (4 Page APIs + 4 Query APIs + 4 Aggregate Query APIs) by reading ALL records from all 4 table variants.';

                    trigger OnAction()
                    var
                        APIPerformanceTester: Codeunit "API Performance Tester";
                    begin
                        APIPerformanceTester.RunAllPerformanceTests();
                        CurrPage.Update(false); // Refresh to show updated best performing API
                    end;
                }
            }

            group(Analysis)
            {
                Caption = 'Results Analysis';

                action(ViewTestResults)
                {
                    Caption = 'View Test Results History';
                    ApplicationArea = All;
                    Image = Report;
                    ToolTip = 'View all performance test results with detailed history, filtering, and sorting capabilities.';

                    trigger OnAction()
                    var
                        TestResultsPage: Page "API Performance Test Results";
                    begin
                        TestResultsPage.Run();
                    end;
                }

                action(ShowBestAPIs)
                {
                    Caption = 'Show Best Performing APIs';
                    ApplicationArea = All;
                    Image = ShowSelected;
                    ToolTip = 'Display the best performing API for each table variant based on average duration.';

                    trigger OnAction()
                    var
                        TestResultsPage: Page "API Performance Test Results";
                    begin
                        TestResultsPage.ShowBestPerformingAPIs();
                    end;
                }

                action(ShowStatistics)
                {
                    Caption = 'Show Statistics';
                    ApplicationArea = All;
                    Image = Statistics;
                    ToolTip = 'Show average, min, max performance statistics by table variant and API type.';

                    trigger OnAction()
                    var
                        TestResultsPage: Page "API Performance Test Results";
                    begin
                        TestResultsPage.ShowPerformanceStatistics();
                    end;
                }

                action(CompareLastRuns)
                {
                    Caption = 'Compare Last 2 Test Runs';
                    ApplicationArea = All;
                    Image = CompareCOA;
                    ToolTip = 'Compare the last 2 test runs side-by-side to see performance improvements or regressions.';

                    trigger OnAction()
                    var
                        TestResultsPage: Page "API Performance Test Results";
                    begin
                        TestResultsPage.CompareLastTwoTestRuns();
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

    local procedure GetBestPerformingAPI(): Text
    var
        TestResults: Record "API Performance Test Results";
        TestResultsPage: Page "API Performance Test Results";
    begin
        if TestResults.IsEmpty then
            exit('No test results yet');

        TestResults.SetCurrentKey("Duration (ms)");
        TestResults.Ascending(true);
        if TestResults.FindFirst() then
            exit(TestResultsPage.BuildAPIName(TestResults."Table Variant", TestResults."API Type"))
        else
            exit('No test results yet');
    end;

    local procedure GetBestPerformingDuration(): Text
    var
        TestResults: Record "API Performance Test Results";
    begin
        if TestResults.IsEmpty then
            exit('-');

        TestResults.SetCurrentKey("Duration (ms)");
        TestResults.Ascending(true);
        if TestResults.FindFirst() then
            exit(Format(TestResults."Duration (ms)") + ' ms')
        else
            exit('-');
    end;
}
