report 50126 ExampleReportWithNotes
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'ExampleReportWithNotes';
    RDLCLayout = 'ExampleReportWithNotes.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(customerNo; "No.")
            {
                IncludeCaption = true;
            }
            column(customerName; Name)
            {
                IncludeCaption = true;
            }
            column(CustomerNote; NoteManagement.GetNotesForRecordRef(MyRecordRef))
            {
                Caption = 'Customer Note';
            }
            trigger OnAfterGetRecord()
            begin
                MyRecordRef.GetTable(Customer);
            end;
        }
    }

    var
        NoteManagement: Codeunit NoteManagement;
        MyRecordRef: RecordRef;
}