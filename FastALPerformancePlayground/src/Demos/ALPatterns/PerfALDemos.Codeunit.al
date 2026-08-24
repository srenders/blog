codeunit 70204 "Perf AL Demos"
{
    procedure Bad_TextConcatenation(Iterations: Integer): Integer
    var
        ResultText: Text;
        I: Integer;
    begin
        // DEMO: Repeated concatenation is intentionally used as the baseline.
        for I := 1 to Iterations do
            ResultText += Format(I) + ',';
        exit(StrLen(ResultText));
    end;

    procedure Good_TextBuilder(Iterations: Integer): Integer
    var
        Builder: TextBuilder;
        ResultText: Text;
        I: Integer;
    begin
        for I := 1 to Iterations do begin
            Builder.Append(Format(I));
            Builder.Append(',');
        end;
        ResultText := Builder.ToText();
        exit(StrLen(ResultText));
    end;

    procedure Bad_TemporaryRecordLookup(Iterations: Integer): Integer
    var
        TempEntry: Record "Perf Demo Entry" temporary;
        I: Integer;
        Hits: Integer;
    begin
        for I := 1 to Iterations do begin
            TempEntry.Init();
            TempEntry."Entry No." := I;
            TempEntry.Description := Format(I);
            TempEntry.Insert();
        end;

        for I := 1 to Iterations do
            if TempEntry.Get(I) then
                Hits += 1;
        exit(Hits);
    end;

    procedure Good_DictionaryLookup(Iterations: Integer): Integer
    var
        Values: Dictionary of [Integer, Text];
        I: Integer;
        Value: Text;
        Hits: Integer;
    begin
        for I := 1 to Iterations do
            Values.Add(I, Format(I));

        for I := 1 to Iterations do
            if Values.Get(I, Value) then
                Hits += 1;
        exit(Hits);
    end;
}
