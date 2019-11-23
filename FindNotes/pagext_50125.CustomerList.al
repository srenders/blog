pageextension 50126 CustomerList_Ext extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(FieldNotes; NoteManagement.GetNotesForRecordRef(MyRecordRef))
            {
                ApplicationArea = all;
                Width = 250;
            }
        }
        addlast(FactBoxes)
        {
            systempart(notes; Notes)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    begin
        MyRecordRef.GetTable(Rec);
    end;

    var
        NoteManagement: Codeunit NoteManagement;
        MyRecordRef: RecordRef;
}