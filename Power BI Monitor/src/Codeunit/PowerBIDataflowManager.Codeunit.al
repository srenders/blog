codeunit 90135 "Power BI Dataflow Manager"
{
    // Specialized management for Power BI dataflows

    var
        PowerBIHttpClient: Codeunit "Power BI Http Client";
        PowerBIJsonProcessor: Codeunit "Power BI Json Processor";

    /// <summary>
    /// Synchronizes dataflows for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to sync dataflows for</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeDataflows(WorkspaceId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL for dataflows
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId, 'dataflows');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Process dataflows
        ProcessDataflows(WorkspaceId, JsonArray);
        exit(true);
    end;

    /// <summary>
    /// Synchronizes all dataflows across all workspaces
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeAllDataflows(): Boolean
    var
        WorkspaceRec: Record "Power BI Workspace";
        SuccessCount: Integer;
        TotalCount: Integer;
    begin
        WorkspaceRec.SetRange("Sync Enabled", true);
        if not WorkspaceRec.FindSet() then begin
            Message('No workspaces found for dataflow synchronization');
            exit(true);
        end;

        repeat
            TotalCount += 1;
            if SynchronizeDataflows(WorkspaceRec."Workspace ID") then
                SuccessCount += 1;
        until WorkspaceRec.Next() = 0;

        Message('Synchronized dataflows for %1 of %2 workspaces', SuccessCount, TotalCount);
        exit(SuccessCount > 0);
    end;

    /// <summary>
    /// Processes dataflow data from Power BI API response
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID these dataflows belong to</param>
    /// <param name="JsonArray">Array of dataflow objects from API</param>
    local procedure ProcessDataflows(WorkspaceId: Guid; JsonArray: JsonArray)
    var
        DataflowRec: Record "Power BI Dataflow";
        JToken: JsonToken;
        JObject: JsonObject;
        Counter: Integer;
    begin
        Counter := 0;
        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();
            if StoreDataflow(WorkspaceId, JObject, DataflowRec) then
                Counter += 1;
        end;
        Message('Successfully processed %1 dataflows for workspace', Counter);
    end;

    /// <summary>
    /// Stores a single dataflow from JSON data
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID this dataflow belongs to</param>
    /// <param name="JsonObj">JSON object containing dataflow data</param>
    /// <param name="DataflowRec">Dataflow record to populate</param>
    /// <returns>True if dataflow was stored successfully</returns>
    local procedure StoreDataflow(WorkspaceId: Guid; JsonObj: JsonObject; var DataflowRec: Record "Power BI Dataflow"): Boolean
    var
        DataflowId: Guid;
        DataflowName: Text[100];
        Description: Text[250];
    begin
        // Extract basic information
        DataflowId := PowerBIJsonProcessor.GetGuidValue(JsonObj, 'objectId');
        if IsNullGuid(DataflowId) then
            exit(false);

        DataflowName := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'name', ''), 1, MaxStrLen(DataflowName));
        Description := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'description', ''), 1, MaxStrLen(Description));

        // Find or create dataflow record
        if not DataflowRec.Get(DataflowId) then begin
            DataflowRec.Init();
            DataflowRec."Dataflow ID" := DataflowId;
        end;

        // Update dataflow information
        DataflowRec."Workspace ID" := WorkspaceId;
        DataflowRec."Dataflow Name" := DataflowName;
        DataflowRec."Description" := Description;
        DataflowRec."Last Synchronized" := CurrentDateTime();

        // Save record
        if DataflowRec."Dataflow ID" = DataflowId then
            DataflowRec.Modify(true)
        else
            DataflowRec.Insert(true);

        exit(true);
    end;

    /// <summary>
    /// Gets dataflow information by ID
    /// </summary>
    /// <param name="DataflowId">The dataflow ID to retrieve</param>
    /// <param name="DataflowRec">The dataflow record to populate</param>
    /// <returns>True if dataflow was found</returns>
    procedure GetDataflow(DataflowId: Guid; var DataflowRec: Record "Power BI Dataflow"): Boolean
    begin
        exit(DataflowRec.Get(DataflowId));
    end;

    /// <summary>
    /// Validates if a dataflow exists and belongs to an active workspace
    /// </summary>
    /// <param name="DataflowId">The dataflow ID to validate</param>
    /// <returns>True if dataflow is valid and accessible</returns>
    procedure ValidateDataflow(DataflowId: Guid): Boolean
    var
        DataflowRec: Record "Power BI Dataflow";
        WorkspaceRec: Record "Power BI Workspace";
    begin
        if not DataflowRec.Get(DataflowId) then
            exit(false);

        // Check if workspace is enabled for sync
        if not WorkspaceRec.Get(DataflowRec."Workspace ID") then
            exit(false);

        exit(WorkspaceRec."Sync Enabled");
    end;

    /// <summary>
    /// Triggers a refresh for a specific dataflow
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DataflowId">The dataflow ID to refresh</param>
    /// <returns>True if refresh was triggered successfully</returns>
    procedure TriggerDataflowRefresh(WorkspaceId: Guid; DataflowId: Guid): Boolean
    var
        ResponseText: Text;
        EndpointUrl: Text;
        RequestBody: Text;
    begin
        // Build API URL for dataflow refresh
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId,
            'dataflows/' + Format(DataflowId) + '/refreshes');

        // Empty request body for POST
        RequestBody := '{}';

        // Execute POST request to trigger refresh
        exit(PowerBIHttpClient.ExecutePostRequest(EndpointUrl, RequestBody, ResponseText));
    end;

    /// <summary>
    /// Gets refresh history for a specific dataflow
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DataflowId">The dataflow ID to get refresh history for</param>
    /// <returns>True if refresh history was retrieved successfully</returns>
    procedure GetDataflowRefreshHistory(WorkspaceId: Guid; DataflowId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL for dataflow refresh history
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId,
            'dataflows/' + Format(DataflowId) + '/transactions?$top=10');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // For now, just return success. In a full implementation, you would
        // process the refresh history and store it in appropriate tables
        exit(true);
    end;
}