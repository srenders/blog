codeunit 70210 "Perf Company Open Demo"
{
    procedure EnableTeachingExample()
    begin
        TeachingExampleEnabled := true;
    end;

    procedure DisableTeachingExample()
    begin
        TeachingExampleEnabled := false;
    end;

    procedure IsTeachingExampleEnabled(): Boolean
    begin
        exit(TeachingExampleEnabled);
    end;

    // DEMO: Do not enable expensive initialization work in a real environment.
    // A company-open/session-initialization subscriber would run before normal work
    // begins, making every user pay for the added cost. The executable subscriber
    // is intentionally omitted so this extension never delays company opening.
    var
        TeachingExampleEnabled: Boolean;
}