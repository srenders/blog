codeunit 50126 NoteManagement
{
    trigger OnRun()
    begin

    end;

    procedure RecordRefHasNote(MyRec: RecordRef): Boolean
    var
        RecordLink: Record "Record Link";
    begin
        Clear(RecordLink);
        RecordLink.SetRange("Record ID", MyRec.RecordId());
        RecordLink.SetRange(Type, RecordLink.Type::Note);
        if RecordLink.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    procedure GetNotesForRecordRef(MyRec: RecordRef): text[250]
    var
        RecordLink: Record "Record Link";
        TypeHelper: Codeunit "Record Link Management";
        Result: text;
    begin
        Clear(RecordLink);
        clear(Result);
        RecordLink.SetRange("Record ID", MyRec.RecordId());
        RecordLink.SetRange(Type, RecordLink.Type::Note);
        if RecordLink.FindSet() then
            repeat
                RecordLink.CalcFields(Note);
                Result += TypeHelper.ReadNote(RecordLink);
            until RecordLink.Next() = 0;
        exit(copystr(Result, 1, 250));
    end;
}