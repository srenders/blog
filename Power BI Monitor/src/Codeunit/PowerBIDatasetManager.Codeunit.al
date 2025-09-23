codeunit 90133 "Power BI Dataset Manager"
{
    // Dataset-specific operations for Power BI Monitor
    Permissions = tabledata "Power BI Dataset" = RIMD;

    var
        PowerBIHttpClient: Codeunit "Power BI Http Client";
        PowerBIJsonProcessor: Codeunit "Power BI Json Processor";

    /// <summary>
    /// Synchronizes datasets for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to synchronize</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeDatasets(WorkspaceId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId, 'datasets');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Process datasets
        ProcessDatasets(JsonArray, WorkspaceId);
        exit(true);
    end;

    /// <summary>
    /// Triggers a refresh for a specific dataset
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DatasetId">The dataset ID</param>
    /// <returns>True if refresh was successfully triggered</returns>
    procedure TriggerDatasetRefresh(WorkspaceId: Guid; DatasetId: Guid): Boolean
    var
        ResponseText: Text;
        EndpointUrl: Text;
        RequestBody: Text;
    begin
        // Build API URL
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId,
            'datasets/' + PowerBIHttpClient.FormatGuidForUrl(DatasetId) + '/refreshes');

        // Empty JSON body for refresh trigger
        RequestBody := '{}';

        // Execute POST request
        exit(PowerBIHttpClient.ExecutePostRequest(EndpointUrl, RequestBody, ResponseText));
    end;

    /// <summary>
    /// Gets refresh history for a specific dataset
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DatasetId">The dataset ID</param>
    /// <returns>True if refresh history was successfully retrieved</returns>
    procedure GetDatasetRefreshHistory(WorkspaceId: Guid; DatasetId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL with top 5 results
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId,
            'datasets/' + PowerBIHttpClient.FormatGuidForUrl(DatasetId) + '/refreshes?$top=5');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Process refresh history
        ProcessRefreshHistory(JsonArray, WorkspaceId, DatasetId);
        exit(true);
    end;

    local procedure ProcessDatasets(JsonArray: JsonArray; WorkspaceId: Guid)
    var
        PowerBIDataset: Record "Power BI Dataset";
        JToken: JsonToken;
        JObject: JsonObject;
        DatasetId: Guid;
        DatasetName: Text;
        WebUrl: Text;
        ConfiguredBy: Text;
        IsRefreshable: Boolean;
    begin
        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();

            // Extract dataset information using helper
            if PowerBIJsonProcessor.ExtractDatasetInfo(JObject, DatasetId, DatasetName, WebUrl, ConfiguredBy, IsRefreshable) then begin
                // Create or update dataset record
                CreateOrUpdateDataset(PowerBIDataset, DatasetId, WorkspaceId, DatasetName, WebUrl, ConfiguredBy, IsRefreshable);

                // Get refresh history for this dataset
                GetDatasetRefreshHistory(WorkspaceId, DatasetId);
            end;
        end;
    end;

    local procedure CreateOrUpdateDataset(var PowerBIDataset: Record "Power BI Dataset"; DatasetId: Guid; WorkspaceId: Guid; DatasetName: Text; WebUrl: Text; ConfiguredBy: Text; IsRefreshable: Boolean)
    begin
        // Insert or update dataset record
        if not PowerBIDataset.Get(DatasetId, WorkspaceId) then begin
            PowerBIDataset.Init();
            PowerBIDataset."Dataset ID" := DatasetId;
            PowerBIDataset."Workspace ID" := WorkspaceId;
            PowerBIDataset.Insert();
        end;

        // Update fields
        PowerBIDataset."Dataset Name" := CopyStr(DatasetName, 1, MaxStrLen(PowerBIDataset."Dataset Name"));
        PowerBIDataset."Web URL" := CopyStr(WebUrl, 1, MaxStrLen(PowerBIDataset."Web URL"));
        PowerBIDataset."Configured By" := CopyStr(ConfiguredBy, 1, MaxStrLen(PowerBIDataset."Configured By"));
        PowerBIDataset."Is Refreshable" := IsRefreshable;
        PowerBIDataset."Last Synchronized" := CurrentDateTime();
        PowerBIDataset.Modify();
    end;

    local procedure ProcessRefreshHistory(JsonArray: JsonArray; WorkspaceId: Guid; DatasetId: Guid)
    var
        PowerBIDataset: Record "Power BI Dataset";
        JToken: JsonToken;
        JObject: JsonObject;
        RefreshType: Text;
        Status: Text;
        StartTime: DateTime;
        EndTime: DateTime;
        DurationMinutes: Decimal;
        TotalDuration: Decimal;
        RefreshCount: Integer;
    begin
        if not PowerBIDataset.Get(DatasetId, WorkspaceId) then
            exit;

        TotalDuration := 0;
        RefreshCount := 0;

        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();

            // Extract refresh information using helper
            if PowerBIJsonProcessor.ExtractRefreshInfo(JObject, RefreshType, Status, StartTime, EndTime) then begin
                RefreshCount += 1;

                // Update latest refresh info on first iteration (most recent)
                if RefreshCount = 1 then
                    UpdateLatestRefreshInfo(PowerBIDataset, Status, StartTime, EndTime);

                // Calculate duration and add to total
                if EndTime <> 0DT then begin
                    DurationMinutes := PowerBIJsonProcessor.CalculateDurationMinutes(StartTime, EndTime);
                    TotalDuration += DurationMinutes;
                end;
            end;
        end;

        // Calculate and update averages
        if RefreshCount > 0 then
            UpdateRefreshStatistics(PowerBIDataset, TotalDuration, RefreshCount);

        PowerBIDataset.Modify();
    end;

    local procedure UpdateLatestRefreshInfo(var PowerBIDataset: Record "Power BI Dataset"; Status: Text; StartTime: DateTime; EndTime: DateTime)
    var
        DurationMinutes: Decimal;
    begin
        PowerBIDataset."Last Refresh" := StartTime;
        PowerBIDataset."Last Refresh Status" := CopyStr(Status, 1, MaxStrLen(PowerBIDataset."Last Refresh Status"));

        if EndTime <> 0DT then begin
            DurationMinutes := PowerBIJsonProcessor.CalculateDurationMinutes(StartTime, EndTime);
            PowerBIDataset."Last Refresh Duration (Min)" := DurationMinutes;
        end;
    end;

    local procedure UpdateRefreshStatistics(var PowerBIDataset: Record "Power BI Dataset"; TotalDuration: Decimal; RefreshCount: Integer)
    begin
        if RefreshCount > 0 then begin
            PowerBIDataset."Average Refresh Duration (Min)" := TotalDuration / RefreshCount;
            PowerBIDataset."Refresh Count" := RefreshCount;
        end;
    end;

    /// <summary>
    /// Gets all refreshable datasets in a workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="RefreshableDatasets">Record set of refreshable datasets</param>
    /// <returns>Number of refreshable datasets found</returns>
    procedure GetRefreshableDatasets(WorkspaceId: Guid; var RefreshableDatasets: Record "Power BI Dataset"): Integer
    begin
        RefreshableDatasets.Reset();
        RefreshableDatasets.SetRange("Workspace ID", WorkspaceId);
        RefreshableDatasets.SetRange("Is Refreshable", true);
        exit(RefreshableDatasets.Count());
    end;

    /// <summary>
    /// Gets datasets with failed last refresh
    /// </summary>
    /// <param name="FailedDatasets">Record set of datasets with failed refresh</param>
    /// <returns>Number of datasets with failed refresh</returns>
    procedure GetFailedRefreshDatasets(var FailedDatasets: Record "Power BI Dataset"): Integer
    begin
        FailedDatasets.Reset();
        FailedDatasets.SetFilter("Last Refresh Status", '*Failed*|*Error*');
        exit(FailedDatasets.Count());
    end;

    /// <summary>
    /// Calculates average refresh time across all datasets
    /// </summary>
    /// <returns>Average refresh time in minutes</returns>
    procedure CalculateAverageRefreshTime(): Decimal
    var
        PowerBIDataset: Record "Power BI Dataset";
        TotalTime: Decimal;
        DatasetCount: Integer;
    begin
        PowerBIDataset.Reset();
        PowerBIDataset.SetFilter("Average Refresh Duration (Min)", '>0');

        if PowerBIDataset.FindSet() then
            repeat
                TotalTime += PowerBIDataset."Average Refresh Duration (Min)";
                DatasetCount += 1;
            until PowerBIDataset.Next() = 0;

        if DatasetCount > 0 then
            exit(TotalTime / DatasetCount);

        exit(0);
    end;
}