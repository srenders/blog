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
    /// Processes dataflow data from Power BI API response and updates refresh history
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID these dataflows belong to</param>
    /// <param name="JsonArray">Array of dataflow objects from API</param>
    local procedure ProcessDataflows(WorkspaceId: Guid; JsonArray: JsonArray)
    var
        DataflowRec: Record "Power BI Dataflow";
        JToken: JsonToken;
        JObject: JsonObject;
        Counter: Integer;
        RefreshHistoryCounter: Integer;
    begin
        Counter := 0;
        RefreshHistoryCounter := 0;
        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();
            if StoreDataflow(WorkspaceId, JObject, DataflowRec) then begin
                Counter += 1;
                // Also get refresh history for each dataflow to populate refresh-related fields
                if GetDataflowRefreshHistory(WorkspaceId, DataflowRec."Dataflow ID") then
                    RefreshHistoryCounter += 1;
            end;
        end;
        Message('Successfully processed %1 dataflows and updated refresh history for %2 dataflows', Counter, RefreshHistoryCounter);
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
        DataflowName: Text;
        Description: Text;
        ConfiguredBy: Text;
        WebUrl: Text;
    begin
        // Extract dataflow information using proper JSON processor
        if not PowerBIJsonProcessor.ExtractDataflowInfo(JsonObj, DataflowId, DataflowName, Description, ConfiguredBy) then
            exit(false);

        // Find or create dataflow record
        if not DataflowRec.Get(DataflowId, WorkspaceId) then begin
            DataflowRec.Init();
            DataflowRec."Dataflow ID" := DataflowId;
            DataflowRec."Workspace ID" := WorkspaceId;
        end;

        // Update dataflow information with proper text length handling
        DataflowRec."Dataflow Name" := CopyStr(DataflowName, 1, MaxStrLen(DataflowRec."Dataflow Name"));
        DataflowRec."Description" := CopyStr(Description, 1, MaxStrLen(DataflowRec."Description"));
        DataflowRec."Configured By" := CopyStr(ConfiguredBy, 1, MaxStrLen(DataflowRec."Configured By"));

        WebUrl := PowerBIJsonProcessor.BuildDataflowWebUrl(WorkspaceId, DataflowId);
        DataflowRec."Web URL" := CopyStr(WebUrl, 1, MaxStrLen(DataflowRec."Web URL"));
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

        // Process refresh history and update dataflow record
        ProcessDataflowRefreshHistory(WorkspaceId, DataflowId, JsonArray);
        exit(true);
    end;

    /// <summary>
    /// Processes dataflow refresh history and updates the dataflow record with latest refresh information
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DataflowId">The dataflow ID</param>
    /// <param name="JsonArray">Array of refresh transaction objects</param>
    local procedure ProcessDataflowRefreshHistory(WorkspaceId: Guid; DataflowId: Guid; JsonArray: JsonArray)
    var
        DataflowRec: Record "Power BI Dataflow";
        JToken: JsonToken;
        JObject: JsonObject;
        RefreshType: Text;
        Status: Text;
        StartTime: DateTime;
        EndTime: DateTime;
        Duration: Decimal;
        TotalDuration: Decimal;
        SuccessfulCount: Integer;
        TotalCount: Integer;
        IsFirst: Boolean;
    begin
        if not DataflowRec.Get(DataflowId, WorkspaceId) then
            exit;

        IsFirst := true;
        TotalDuration := 0;
        SuccessfulCount := 0;
        TotalCount := 0;

        // Process each refresh transaction
        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();
            if PowerBIJsonProcessor.ExtractRefreshInfo(JObject, RefreshType, Status, StartTime, EndTime) then begin
                TotalCount += 1;

                // Calculate duration if both times are present
                if (StartTime <> 0DT) and (EndTime <> 0DT) then begin
                    Duration := (EndTime - StartTime) / 60000; // Convert to minutes
                    TotalDuration += Duration;
                end;

                // Count successful refreshes
                if Status = 'Completed' then
                    SuccessfulCount += 1;

                // Update with latest refresh info (first item is most recent)
                if IsFirst then begin
                    DataflowRec."Last Refresh" := StartTime;
                    DataflowRec."Last Refresh Status" := CopyStr(Status, 1, MaxStrLen(DataflowRec."Last Refresh Status"));
                    if Duration > 0 then
                        DataflowRec."Last Refresh Duration (Min)" := Duration;
                    IsFirst := false;
                end;
            end;
        end;

        // Update aggregate statistics
        if TotalCount > 0 then begin
            DataflowRec."Refresh Count" := TotalCount;
            if SuccessfulCount > 0 then
                DataflowRec."Average Refresh Duration (Min)" := TotalDuration / SuccessfulCount;
        end;

        DataflowRec."Last Synchronized" := CurrentDateTime();
        DataflowRec.Modify(true);
    end;
}