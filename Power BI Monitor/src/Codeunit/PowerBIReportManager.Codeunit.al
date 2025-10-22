codeunit 90137 "Power BI Report Manager"
{
    // Specialized management for Power BI reports

    var
        PowerBIHttpClient: Codeunit "Power BI Http Client";
        PowerBIJsonProcessor: Codeunit "Power BI Json Processor";

    /// <summary>
    /// Synchronizes reports for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to sync reports for</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeReports(WorkspaceId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL for reports
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId, 'reports');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Process reports
        ProcessReports(WorkspaceId, JsonArray);
        exit(true);
    end;

    /// <summary>
    /// Synchronizes all reports across all workspaces
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeAllReports(): Boolean
    var
        WorkspaceRec: Record "Power BI Workspace";
        SuccessCount: Integer;
        TotalCount: Integer;
    begin
        WorkspaceRec.SetRange("Sync Enabled", true);
        if not WorkspaceRec.FindSet() then
            exit(true);

        repeat
            TotalCount += 1;
            if SynchronizeReports(WorkspaceRec."Workspace ID") then
                SuccessCount += 1;
        until WorkspaceRec.Next() = 0;

        // Message('Synchronized reports for %1 of %2 workspaces', SuccessCount, TotalCount);
        exit(SuccessCount > 0);
    end;

    /// <summary>
    /// Processes report data from Power BI API response
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID these reports belong to</param>
    /// <param name="JsonArray">Array of report objects from API</param>
    local procedure ProcessReports(WorkspaceId: Guid; JsonArray: JsonArray)
    var
        ReportRec: Record "Power BI Report";
        WorkspaceRec: Record "Power BI Workspace";
        JToken: JsonToken;
        JObject: JsonObject;
        Counter: Integer;
    begin
        // Skip if workspace doesn't exist in BC yet
        WorkspaceRec.SetRange("Workspace ID", WorkspaceId);
        if WorkspaceRec.IsEmpty() then
            exit;

        Counter := 0;
        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();
            if StoreReport(WorkspaceId, JObject, ReportRec) then
                Counter += 1;
        end;
        // Message('Successfully processed %1 reports for workspace', Counter);
    end;

    /// <summary>
    /// Stores a single report from JSON data
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID this report belongs to</param>
    /// <param name="JsonObj">JSON object containing report data</param>
    /// <param name="ReportRec">Report record to populate</param>
    /// <returns>True if report was stored successfully</returns>
    local procedure StoreReport(WorkspaceId: Guid; JsonObj: JsonObject; var ReportRec: Record "Power BI Report"): Boolean
    var
        ReportId: Guid;
        ReportName: Text[100];
        DatasetId: Guid;
        EmbedUrl: Text[250];
        WebUrl: Text[250];
    begin
        // Extract basic information
        ReportId := PowerBIJsonProcessor.GetGuidValue(JsonObj, 'id');
        if IsNullGuid(ReportId) then
            exit(false);

        ReportName := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'name', ''), 1, MaxStrLen(ReportName));
        DatasetId := PowerBIJsonProcessor.GetGuidValue(JsonObj, 'datasetId');
        EmbedUrl := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'embedUrl', ''), 1, MaxStrLen(EmbedUrl));
        WebUrl := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'webUrl', ''), 1, MaxStrLen(WebUrl));

        // Find or create report record using composite key (Report ID + Workspace ID)
        ReportRec.SetRange("Report ID", ReportId);
        ReportRec.SetRange("Workspace ID", WorkspaceId);
        if not ReportRec.FindFirst() then begin
            ReportRec.Init();
            ReportRec."Report ID" := ReportId;
            ReportRec."Workspace ID" := WorkspaceId;
            ReportRec.Name := ReportName;
            ReportRec."Dataset ID" := DatasetId;
            ReportRec."Embed URL" := EmbedUrl;
            ReportRec."Web URL" := WebUrl;
            ReportRec."Last Sync" := CurrentDateTime();
            ReportRec.Insert(false);
        end else begin
            // Update report information
            ReportRec.Name := ReportName;
            ReportRec."Dataset ID" := DatasetId;
            ReportRec."Embed URL" := EmbedUrl;
            ReportRec."Web URL" := WebUrl;
            ReportRec."Last Sync" := CurrentDateTime();
            ReportRec.Modify(false);
        end;

        exit(true);
    end;

    /// <summary>
    /// Gets report information by ID and workspace
    /// </summary>
    /// <param name="ReportId">The report ID to retrieve</param>
    /// <param name="WorkspaceId">The workspace ID the report belongs to</param>
    /// <param name="ReportRec">The report record to populate</param>
    /// <returns>True if report was found</returns>
    procedure GetReport(ReportId: Guid; WorkspaceId: Guid; var ReportRec: Record "Power BI Report"): Boolean
    begin
        exit(ReportRec.Get(ReportId, WorkspaceId));
    end;

    /// <summary>
    /// Validates if a report exists and belongs to an active workspace
    /// </summary>
    /// <param name="ReportId">The report ID to validate</param>
    /// <param name="WorkspaceId">The workspace ID to validate</param>
    /// <returns>True if report is valid and accessible</returns>
    procedure ValidateReport(ReportId: Guid; WorkspaceId: Guid): Boolean
    var
        ReportRec: Record "Power BI Report";
        WorkspaceRec: Record "Power BI Workspace";
    begin
        if not ReportRec.Get(ReportId, WorkspaceId) then
            exit(false);

        // Check if workspace is enabled for sync
        if not WorkspaceRec.Get(ReportRec."Workspace ID") then
            exit(false);

        exit(WorkspaceRec."Sync Enabled");
    end;
}