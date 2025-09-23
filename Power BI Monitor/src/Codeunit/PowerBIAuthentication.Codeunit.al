codeunit 90130 "Power BI Authentication"
{
    // Authentication and token management for Power BI API operations
    Permissions = tabledata "Power BI Setup" = R;

    var
        CachedToken: Text;
        TokenExpiryTime: DateTime;
        TokenCacheDurationMinutes: Integer;

    trigger OnRun()
    begin
        TokenCacheDurationMinutes := 50; // Cache token for 50 minutes (expires in 60)
    end;

    /// <summary>
    /// Gets a valid authentication token for Power BI API calls
    /// </summary>
    /// <param name="AuthToken">The bearer token to use in API calls</param>
    /// <returns>True if token was successfully obtained</returns>
    procedure GetAuthToken(var AuthToken: Text): Boolean
    begin
        Clear(AuthToken);

        // Check if we have a cached valid token
        if IsCachedTokenValid() then begin
            AuthToken := CachedToken;
            exit(true);
        end;

        // Get new token
        if RequestNewToken(AuthToken) then begin
            CacheToken(AuthToken);
            exit(true);
        end;

        exit(false);
    end;

    /// <summary>
    /// Forces a refresh of the authentication token
    /// </summary>
    /// <param name="AuthToken">The new bearer token</param>
    /// <returns>True if token was successfully refreshed</returns>
    procedure RefreshToken(var AuthToken: Text): Boolean
    begin
        ClearCachedToken();
        exit(GetAuthToken(AuthToken));
    end;

    /// <summary>
    /// Validates the current setup configuration
    /// </summary>
    /// <returns>True if configuration is valid</returns>
    procedure ValidateConfiguration(): Boolean
    var
        PowerBISetup: Record "Power BI Setup";
    begin
        if not PowerBISetup.Get('') then begin
            Message('Power BI Setup is not configured. Please configure authentication settings first.');
            exit(false);
        end;

        if (PowerBISetup."Client ID" = '') or (PowerBISetup."Client Secret" = '') or (PowerBISetup."Tenant ID" = '') then begin
            Message('Power BI Setup is incomplete. Please configure Client ID, Client Secret, and Tenant ID.');
            exit(false);
        end;

        exit(true);
    end;

    /// <summary>
    /// Gets the Power BI Setup record
    /// </summary>
    /// <param name="PowerBISetup">The setup record</param>
    /// <returns>True if setup record exists</returns>
    procedure GetSetupRecord(var PowerBISetup: Record "Power BI Setup"): Boolean
    begin
        exit(PowerBISetup.Get(''));
    end;

    local procedure IsCachedTokenValid(): Boolean
    begin
        if CachedToken = '' then
            exit(false);

        if TokenExpiryTime = 0DT then
            exit(false);

        // Check if token is still valid (with 10 minute buffer)
        exit(CurrentDateTime() < (TokenExpiryTime - 600000)); // 10 minutes in milliseconds
    end;

    local procedure CacheToken(AuthToken: Text)
    begin
        CachedToken := AuthToken;
        TokenExpiryTime := CurrentDateTime() + (TokenCacheDurationMinutes * 60000); // Convert minutes to milliseconds
    end;

    local procedure ClearCachedToken()
    begin
        Clear(CachedToken);
        Clear(TokenExpiryTime);
    end;

    local procedure RequestNewToken(var AuthToken: Text): Boolean
    var
        PowerBISetup: Record "Power BI Setup";
    begin
        if not ValidateConfiguration() then
            exit(false);

        if not GetSetupRecord(PowerBISetup) then
            exit(false);

        exit(ExecuteClientCredentialsFlow(PowerBISetup, AuthToken));
    end;

    local procedure ExecuteClientCredentialsFlow(PowerBISetup: Record "Power BI Setup"; var AuthToken: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        RequestBody: Text;
        TokenUrl: Text;
    begin
        // Build token URL
        TokenUrl := PowerBISetup."Authority URL" + PowerBISetup."Tenant ID" + '/oauth2/v2.0/token';

        // Build request body
        RequestBody := BuildTokenRequestBody(PowerBISetup);

        // Setup HTTP request
        if not SetupTokenRequest(HttpRequestMessage, TokenUrl, RequestBody, HttpContent, HttpHeaders) then
            exit(false);

        // Send request with enhanced error handling
        if not ExecuteTokenRequest(HttpClient, HttpRequestMessage, HttpResponseMessage, TokenUrl) then
            exit(false);

        // Process response
        exit(ProcessTokenResponse(HttpResponseMessage, PowerBISetup, TokenUrl, AuthToken));
    end;

    local procedure BuildTokenRequestBody(PowerBISetup: Record "Power BI Setup"): Text
    begin
        exit('grant_type=client_credentials' +
             '&client_id=' + PowerBISetup."Client ID" +
             '&client_secret=' + PowerBISetup."Client Secret" +
             '&scope=https://analysis.windows.net/powerbi/api/.default');
    end;

    local procedure SetupTokenRequest(var HttpRequestMessage: HttpRequestMessage; TokenUrl: Text; RequestBody: Text; var HttpContent: HttpContent; var HttpHeaders: HttpHeaders): Boolean
    begin
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(TokenUrl);
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Clear();
        HttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpRequestMessage.Content := HttpContent;
        exit(true);
    end;

    local procedure ExecuteTokenRequest(var HttpClient: HttpClient; var HttpRequestMessage: HttpRequestMessage; var HttpResponseMessage: HttpResponseMessage; TokenUrl: Text): Boolean
    begin
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('HTTP Send operation failed.\n\n' +
                  'This error typically indicates:\n' +
                  '1. HTTP operations are disabled in this Business Central environment\n' +
                  '2. Network connectivity issues to Azure AD\n' +
                  '3. Firewall blocking outbound HTTPS requests\n' +
                  '4. Extension lacks proper HTTP client permissions\n\n' +
                  'Solutions:\n' +
                  '- Contact your BC administrator to enable HTTP client operations\n' +
                  '- Check if this is a Sandbox environment with restrictions\n' +
                  '- Verify network connectivity to login.microsoftonline.com\n' +
                  '- Ensure the extension has proper permissions in app.json\n\n' +
                  'Target URL: %1', TokenUrl);
        exit(true);
    end;

    local procedure ProcessTokenResponse(var HttpResponseMessage: HttpResponseMessage; PowerBISetup: Record "Power BI Setup"; TokenUrl: Text; var AuthToken: Text): Boolean
    var
        JObject: JsonObject;
        JToken: JsonToken;
        ResponseText: Text;
    begin
        // Read response
        HttpResponseMessage.Content().ReadAs(ResponseText);

        // Check status
        if not HttpResponseMessage.IsSuccessStatusCode() then
            Error('Authentication failed with status %1.\n\n' +
                  'Current configuration:\n' +
                  '- Tenant ID: %2\n' +
                  '- Client ID: %3\n' +
                  '- Authority URL: %4\n' +
                  '- Token URL: %5\n\n' +
                  'Azure AD Response: %6\n\n' +
                  'Common causes by status code:\n' +
                  '- 400: Bad Request (invalid tenant ID, malformed request)\n' +
                  '- 401: Unauthorized (invalid client credentials)\n' +
                  '- 403: Forbidden (missing permissions or no admin consent)\n' +
                  '- 404: Not Found (wrong tenant ID or endpoint)',
                  HttpResponseMessage.HttpStatusCode(),
                  PowerBISetup."Tenant ID", PowerBISetup."Client ID", PowerBISetup."Authority URL", TokenUrl, ResponseText);

        // Parse JSON response
        if JObject.ReadFrom(ResponseText) then begin
            if JObject.Get('access_token', JToken) then begin
                AuthToken := JToken.AsValue().AsText();
                exit(true);
            end else
                Error('Access token not found in response: %1', ResponseText);
        end else
            Error('Failed to parse JSON response: %1', ResponseText);

        exit(false);
    end;
}