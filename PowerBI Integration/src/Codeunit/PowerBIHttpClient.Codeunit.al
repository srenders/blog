codeunit 90131 "Power BI Http Client"
{
    // Standardized HTTP client for Power BI API operations

    var
        PowerBIAuth: Codeunit "Power BI Authentication";

    /// <summary>
    /// Executes a GET request to Power BI API
    /// </summary>
    /// <param name="EndpointUrl">The API endpoint URL</param>
    /// <param name="ResponseText">The response content</param>
    /// <returns>True if request was successful</returns>
    procedure ExecuteGetRequest(EndpointUrl: Text; var ResponseText: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
    begin
        if not SetupGetRequest(HttpRequestMessage, EndpointUrl) then
            exit(false);

        if not ExecuteRequest(HttpClient, HttpRequestMessage, HttpResponseMessage, EndpointUrl) then
            exit(false);

        exit(ProcessResponse(HttpResponseMessage, EndpointUrl, ResponseText));
    end;

    /// <summary>
    /// Executes a POST request to Power BI API
    /// </summary>
    /// <param name="EndpointUrl">The API endpoint URL</param>
    /// <param name="RequestBody">The request body content</param>
    /// <param name="ResponseText">The response content</param>
    /// <returns>True if request was successful</returns>
    procedure ExecutePostRequest(EndpointUrl: Text; RequestBody: Text; var ResponseText: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
    begin
        if not SetupPostRequest(HttpRequestMessage, EndpointUrl, RequestBody) then
            exit(false);

        if not ExecuteRequest(HttpClient, HttpRequestMessage, HttpResponseMessage, EndpointUrl) then
            exit(false);

        exit(ProcessResponse(HttpResponseMessage, EndpointUrl, ResponseText));
    end;

    /// <summary>
    /// Builds a standard Power BI API URL
    /// </summary>
    /// <param name="ResourcePath">The resource path (e.g., 'groups', 'groups/{id}/datasets')</param>
    /// <returns>The complete API URL</returns>
    procedure BuildApiUrl(ResourcePath: Text): Text
    begin
        exit('https://api.powerbi.com/v1.0/myorg/' + ResourcePath);
    end;

    /// <summary>
    /// Builds a workspace-specific API URL
    /// </summary>
    /// <param name="WorkspaceId">The workspace GUID</param>
    /// <param name="ResourcePath">The resource path within the workspace</param>
    /// <returns>The complete API URL</returns>
    procedure BuildWorkspaceApiUrl(WorkspaceId: Guid; ResourcePath: Text): Text
    var
        WorkspaceIdText: Text;
    begin
        WorkspaceIdText := Format(WorkspaceId).Replace('{', '').Replace('}', '');
        exit(BuildApiUrl('groups/' + WorkspaceIdText + '/' + ResourcePath));
    end;

    /// <summary>
    /// Formats a GUID for use in URLs
    /// </summary>
    /// <param name="GuidValue">The GUID to format</param>
    /// <returns>The GUID without braces</returns>
    procedure FormatGuidForUrl(GuidValue: Guid): Text
    begin
        exit(Format(GuidValue).Replace('{', '').Replace('}', ''));
    end;

    local procedure SetupGetRequest(var HttpRequestMessage: HttpRequestMessage; EndpointUrl: Text): Boolean
    var
        HttpHeaders: HttpHeaders;
        AuthToken: Text;
    begin
        // Get authentication token
        if not PowerBIAuth.GetAuthToken(AuthToken) then
            exit(false);

        // Setup request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(EndpointUrl);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', 'Bearer ' + AuthToken);

        exit(true);
    end;

    local procedure SetupPostRequest(var HttpRequestMessage: HttpRequestMessage; EndpointUrl: Text; RequestBody: Text): Boolean
    var
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        AuthToken: Text;
    begin
        // Get authentication token
        if not PowerBIAuth.GetAuthToken(AuthToken) then
            exit(false);

        // Setup content
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Clear();
        HttpHeaders.Add('Content-Type', 'application/json');

        // Setup request
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(EndpointUrl);
        HttpRequestMessage.Content := HttpContent;
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', 'Bearer ' + AuthToken);

        exit(true);
    end;

    local procedure ExecuteRequest(var HttpClient: HttpClient; var HttpRequestMessage: HttpRequestMessage; var HttpResponseMessage: HttpResponseMessage; EndpointUrl: Text): Boolean
    begin
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            Message('Failed to connect to Power BI API - HTTP Send failed for URL: %1', EndpointUrl);
            exit(false);
        end;
        exit(true);
    end;

    local procedure ProcessResponse(var HttpResponseMessage: HttpResponseMessage; EndpointUrl: Text; var ResponseText: Text): Boolean
    begin
        // Read response content
        if not HttpResponseMessage.Content().ReadAs(ResponseText) then begin
            Message('Failed to read Power BI API response for URL: %1', EndpointUrl);
            exit(false);
        end;

        // Check HTTP status
        if not HttpResponseMessage.IsSuccessStatusCode() then begin
            HandleApiError(HttpResponseMessage, EndpointUrl, ResponseText);
            exit(false);
        end;

        exit(true);
    end;

    local procedure HandleApiError(var HttpResponseMessage: HttpResponseMessage; EndpointUrl: Text; ResponseText: Text)
    var
        StatusCode: Integer;
        ErrorMessage: Text;
    begin
        StatusCode := HttpResponseMessage.HttpStatusCode();

        case StatusCode of
            400:
                ErrorMessage := 'Bad Request - Invalid parameters or malformed request';
            401:
                ErrorMessage := 'Unauthorized - Check authentication settings and permissions';
            403:
                ErrorMessage := 'Forbidden - Insufficient permissions or admin consent required';
            404:
                ErrorMessage := 'Not Found - Resource does not exist or access denied';
            429:
                ErrorMessage := 'Too Many Requests - API rate limit exceeded, try again later';
            500:
                ErrorMessage := 'Internal Server Error - Power BI service error';
            503:
                ErrorMessage := 'Service Unavailable - Power BI service temporarily unavailable';
            else
                ErrorMessage := 'Unexpected error occurred';
        end;

        Message('Power BI API request failed.\nStatus: %1 (%2)\nURL: %3\nError: %4\nResponse: %5',
                StatusCode, ErrorMessage, EndpointUrl, ErrorMessage, CopyStr(ResponseText, 1, 500));
    end;

    /// <summary>
    /// Validates that a response contains the expected JSON structure
    /// </summary>
    /// <param name="ResponseText">The JSON response text</param>
    /// <param name="JsonArray">The extracted JSON array from the 'value' property</param>
    /// <returns>True if JSON is valid and contains expected structure</returns>
    procedure ValidateJsonArrayResponse(ResponseText: Text; var JsonArray: JsonArray): Boolean
    var
        JObject: JsonObject;
        JToken: JsonToken;
    begin
        if not JObject.ReadFrom(ResponseText) then begin
            Message('Failed to parse API response as JSON');
            exit(false);
        end;

        if not JObject.Get('value', JToken) then begin
            Message('API response does not contain "value" property');
            exit(false);
        end;

        if not JToken.IsArray() then begin
            Message('API response "value" is not an array');
            exit(false);
        end;

        JsonArray := JToken.AsArray();
        exit(true);
    end;

    /// <summary>
    /// Validates that a JSON response was successfully parsed
    /// </summary>
    /// <param name="ResponseText">The JSON response text</param>
    /// <param name="JsonObject">The parsed JSON object</param>
    /// <returns>True if JSON was successfully parsed</returns>
    procedure ValidateJsonResponse(ResponseText: Text; var JsonObject: JsonObject): Boolean
    begin
        if not JsonObject.ReadFrom(ResponseText) then begin
            Message('Failed to parse API response as JSON: %1', CopyStr(ResponseText, 1, 200));
            exit(false);
        end;
        exit(true);
    end;
}