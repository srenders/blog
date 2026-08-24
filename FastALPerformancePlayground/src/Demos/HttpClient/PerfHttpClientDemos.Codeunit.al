codeunit 70209 "Perf HttpClient Demos"
{
    procedure Bad_SynchronousHttpRequest(Url: Text): Integer
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseText: Text;
    begin
        // DEMO: HttpClient.Get blocks this AL session while the external service responds.
        if not Client.Get(Url, Response) then
            Error('The HTTP request could not be sent.');

        if not Response.IsSuccessStatusCode() then
            Error('The HTTP service returned status %1.', Response.HttpStatusCode());

        if not Response.Content().ReadAs(ResponseText) then
            Error('The HTTP response body could not be read.');

        exit(StrLen(ResponseText));
    end;
}