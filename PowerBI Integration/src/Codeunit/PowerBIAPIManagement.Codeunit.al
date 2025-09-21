codeunit 90110 "Power BI API Management"
{
    // Orchestrator for Power BI API operations using specialized components
    Permissions = tabledata "Power BI Setup" = R,
                  tabledata "Power BI Workspace" = RIMD,
                  tabledata "Power BI Dataset" = RIMD,
                  tabledata "Power BI Dataflow" = RIMD;

    var
        PowerBIHttpClient: Codeunit "Power BI Http Client";
        PowerBIJsonProcessor: Codeunit "Power BI Json Processor";
        PowerBIDatasetManager: Codeunit "Power BI Dataset Manager";

    trigger OnRun()
    begin
    end;

    procedure SynchronizeWorkspaces(): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL
        EndpointUrl := PowerBIHttpClient.BuildApiUrl('groups');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Check for empty results
        if JsonArray.Count() = 0 then begin
            Message('No workspaces found. This means:\n' +
                    '1. Service principal has no workspace access\n' +
                    '2. Add Client ID to workspace members\n' +
                    '3. Or enable tenant-wide service principal access\n' +
                    '4. Workspaces need Admin/Member permissions for service principals');
            exit(true);
        end;

        // Process workspaces
        Message('Found %1 workspaces in API response', JsonArray.Count());
        ProcessWorkspaces(JsonArray);
        exit(true);
    end;

    procedure SynchronizeDatasets(WorkspaceId: Guid): Boolean
    begin
        // Delegate to specialized dataset manager
        exit(PowerBIDatasetManager.SynchronizeDatasets(WorkspaceId));
    end;

    procedure GetDatasetRefreshHistory(WorkspaceId: Guid; DatasetId: Guid): Boolean
    begin
        // Delegate to specialized dataset manager
        exit(PowerBIDatasetManager.GetDatasetRefreshHistory(WorkspaceId, DatasetId));
    end;

    procedure TriggerDatasetRefresh(WorkspaceId: Guid; DatasetId: Guid): Boolean
    begin
        // Delegate to specialized dataset manager
        exit(PowerBIDatasetManager.TriggerDatasetRefresh(WorkspaceId, DatasetId));
    end;

    procedure SynchronizeAllData(): Boolean
    var
        PowerBIWorkspace: Record "Power BI Workspace";
        SyncErrors: Text;
        SuccessfulWorkspaces: Integer;
        WorkspaceFailedMsg: Label 'Workspace %1 sync failed. ', Comment = '%1 = Workspace Name';
    begin
        // First synchronize workspaces
        if not SynchronizeWorkspaces() then
            SyncErrors := 'Failed to synchronize workspaces. '
        else
            // Synchronize datasets, reports, and dataflows for each workspace
            if PowerBIWorkspace.FindSet() then
                repeat
                    if SynchronizeDatasets(PowerBIWorkspace."Workspace ID") and
                       SynchronizeReports() and
                       SynchronizeDataflows(PowerBIWorkspace."Workspace ID") then
                        SuccessfulWorkspaces += 1
                    else
                        SyncErrors += StrSubstNo(WorkspaceFailedMsg, PowerBIWorkspace."Workspace Name");
                until PowerBIWorkspace.Next() = 0;

        // Return success if all operations completed without major errors
        if SyncErrors = '' then
            exit(true)
        else
            // Return true if some workspaces succeeded
            if SuccessfulWorkspaces > 0 then
                exit(true);

        exit(false);
    end;

    procedure SynchronizeDataflows(WorkspaceId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId, 'dataflows');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Process dataflows
        ProcessDataflows(JsonArray, WorkspaceId);
        exit(true);
    end;

    procedure GetDataflowRefreshHistory(WorkspaceId: Guid; DataflowId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL for dataflow refresh history (uses transactions endpoint)
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId,
            'dataflows/' + PowerBIHttpClient.FormatGuidForUrl(DataflowId) + '/transactions?$top=5');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Process refresh history
        ProcessDataflowRefreshHistory(JsonArray, WorkspaceId, DataflowId);
        exit(true);
    end;

    procedure TriggerDataflowRefresh(WorkspaceId: Guid; DataflowId: Guid): Boolean
    var
        ResponseText: Text;
        EndpointUrl: Text;
        RequestBody: Text;
    begin
        // Build API URL
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId,
            'dataflows/' + PowerBIHttpClient.FormatGuidForUrl(DataflowId) + '/refreshes');

        // Empty JSON body for refresh trigger
        RequestBody := '{}';

        // Execute POST request
        exit(PowerBIHttpClient.ExecutePostRequest(EndpointUrl, RequestBody, ResponseText));
    end;

    local procedure ProcessWorkspaces(JArray: JsonArray)
    var
        PowerBIWorkspace: Record "Power BI Workspace";
        JToken: JsonToken;
        JObject: JsonObject;
        WorkspaceId: Guid;
        WorkspaceName: Text;
        WorkspaceType: Text;
        IsReadOnly: Boolean;
        ProcessedCount: Integer;
    begin
        ProcessedCount := 0;

        foreach JToken in JArray do begin
            JObject := JToken.AsObject();

            // Extract workspace information using helper
            if PowerBIJsonProcessor.ExtractWorkspaceInfo(JObject, WorkspaceId, WorkspaceName, WorkspaceType, IsReadOnly) then begin
                // Insert or update workspace record
                CreateOrUpdateWorkspace(PowerBIWorkspace, WorkspaceId, WorkspaceName, WorkspaceType, IsReadOnly);
                ProcessedCount += 1;
            end else
                Message('Skipping workspace - missing required fields (id or name)');
        end;

        Message('ProcessWorkspaces completed. Processed %1 workspaces.', ProcessedCount);
    end;

    local procedure CreateOrUpdateWorkspace(var PowerBIWorkspace: Record "Power BI Workspace"; WorkspaceId: Guid; WorkspaceName: Text; WorkspaceType: Text; IsReadOnly: Boolean)
    begin
        // Insert or update workspace record
        if not PowerBIWorkspace.Get(WorkspaceId) then begin
            PowerBIWorkspace.Init();
            PowerBIWorkspace."Workspace ID" := WorkspaceId;
            PowerBIWorkspace.Insert();
            Message('Inserted new workspace: %1 (ID: %2)', WorkspaceName, WorkspaceId);
        end else
            Message('Updated existing workspace: %1 (ID: %2)', WorkspaceName, WorkspaceId);

        PowerBIWorkspace."Workspace Name" := CopyStr(WorkspaceName, 1, MaxStrLen(PowerBIWorkspace."Workspace Name"));
        PowerBIWorkspace."Workspace Type" := CopyStr(WorkspaceType, 1, MaxStrLen(PowerBIWorkspace."Workspace Type"));
        PowerBIWorkspace."Is Read Only" := IsReadOnly;
        PowerBIWorkspace."Last Synchronized" := CurrentDateTime();
        PowerBIWorkspace.Modify();
    end;

    /// <summary>
    /// Synchronizes reports for all workspaces
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeReports(): Boolean
    var
        PowerBIWorkspace: Record "Power BI Workspace";
    begin
        // Synchronize reports for all workspaces
        if PowerBIWorkspace.FindSet() then
            repeat
                SynchronizeReportsForWorkspace(PowerBIWorkspace."Workspace ID");
            until PowerBIWorkspace.Next() = 0;
        exit(true);
    end;

    /// <summary>
    /// Synchronizes reports for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to synchronize</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeReportsForWorkspace(WorkspaceId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId, 'reports');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Process reports
        ProcessReports(JsonArray, WorkspaceId);
        exit(true);
    end;

    /// <summary>
    /// Processes report data from API response
    /// </summary>
    /// <param name="JsonArray">The JSON array containing report data</param>
    /// <param name="WorkspaceId">The workspace ID</param>
    local procedure ProcessReports(JsonArray: JsonArray; WorkspaceId: Guid)
    var
        PowerBIReport: Record "Power BI Report";
        JToken: JsonToken;
        JObject: JsonObject;
        ReportId: Guid;
        ReportName: Text;
        WebUrl: Text;
        DatasetId: Guid;
        ReportType: Text;
    begin
        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();

            // Extract report information using helper
            if PowerBIJsonProcessor.ExtractReportInfo(JObject, ReportId, ReportName, WebUrl, DatasetId, ReportType) then
                CreateOrUpdateReport(PowerBIReport, ReportId, WorkspaceId, ReportName, WebUrl, DatasetId, ReportType);
        end;
    end;

    local procedure CreateOrUpdateReport(var PowerBIReport: Record "Power BI Report"; ReportId: Guid; WorkspaceId: Guid; ReportName: Text; WebUrl: Text; DatasetId: Guid; ReportType: Text)
    begin
        // Insert or update report record
        if not PowerBIReport.Get(ReportId, WorkspaceId) then begin
            PowerBIReport.Init();
            PowerBIReport."Report ID" := ReportId;
            PowerBIReport."Workspace ID" := WorkspaceId;
            PowerBIReport.Insert();
        end;

        // Update fields
        PowerBIReport.Name := CopyStr(ReportName, 1, MaxStrLen(PowerBIReport.Name));
        PowerBIReport."Web URL" := CopyStr(WebUrl, 1, MaxStrLen(PowerBIReport."Web URL"));
        PowerBIReport."Dataset ID" := DatasetId;
        PowerBIReport."Report Type" := CopyStr(ReportType, 1, MaxStrLen(PowerBIReport."Report Type"));
        PowerBIReport."Last Sync" := CurrentDateTime();
        PowerBIReport.Modify();
    end;

    /// <summary>
    /// Processes dataflow data from API response
    /// </summary>
    /// <param name="JsonArray">The JSON array containing dataflow data</param>
    /// <param name="WorkspaceId">The workspace ID</param>
    local procedure ProcessDataflows(JsonArray: JsonArray; WorkspaceId: Guid)
    var
        PowerBIDataflow: Record "Power BI Dataflow";
        JToken: JsonToken;
        JObject: JsonObject;
        DataflowId: Guid;
        DataflowName: Text;
        Description: Text;
        ConfiguredBy: Text;
        WebUrl: Text;
    begin
        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();

            // Extract dataflow information using helper
            if PowerBIJsonProcessor.ExtractDataflowInfo(JObject, DataflowId, DataflowName, Description, ConfiguredBy) then begin
                // Construct web URL since API doesn't provide it
                WebUrl := 'https://app.powerbi.com/groups/' +
                         PowerBIHttpClient.FormatGuidForUrl(WorkspaceId) +
                         '/dataflows/' +
                         PowerBIHttpClient.FormatGuidForUrl(DataflowId);

                CreateOrUpdateDataflow(PowerBIDataflow, DataflowId, WorkspaceId, DataflowName, Description, WebUrl, ConfiguredBy);

                // Get refresh history for this dataflow
                GetDataflowRefreshHistory(WorkspaceId, DataflowId);
            end;
        end;
    end;

    local procedure CreateOrUpdateDataflow(var PowerBIDataflow: Record "Power BI Dataflow"; DataflowId: Guid; WorkspaceId: Guid; DataflowName: Text; Description: Text; WebUrl: Text; ConfiguredBy: Text)
    begin
        // Insert or update dataflow record
        if not PowerBIDataflow.Get(DataflowId, WorkspaceId) then begin
            PowerBIDataflow.Init();
            PowerBIDataflow."Dataflow ID" := DataflowId;
            PowerBIDataflow."Workspace ID" := WorkspaceId;
            PowerBIDataflow.Insert();
        end;

        // Update fields
        PowerBIDataflow."Dataflow Name" := CopyStr(DataflowName, 1, MaxStrLen(PowerBIDataflow."Dataflow Name"));
        PowerBIDataflow."Description" := CopyStr(Description, 1, MaxStrLen(PowerBIDataflow."Description"));
        PowerBIDataflow."Web URL" := CopyStr(WebUrl, 1, MaxStrLen(PowerBIDataflow."Web URL"));
        PowerBIDataflow."Configured By" := CopyStr(ConfiguredBy, 1, MaxStrLen(PowerBIDataflow."Configured By"));
        PowerBIDataflow."Last Synchronized" := CurrentDateTime();
        PowerBIDataflow.Modify();
    end;

    local procedure ProcessDataflowRefreshHistory(JsonArray: JsonArray; WorkspaceId: Guid; DataflowId: Guid)
    var
        PowerBIDataflow: Record "Power BI Dataflow";
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
        if not PowerBIDataflow.Get(DataflowId, WorkspaceId) then
            exit;

        TotalDuration := 0;
        RefreshCount := 0;

        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();

            // Initialize variables before extraction
            Clear(RefreshType);
            Clear(Status);
            Clear(StartTime);
            Clear(EndTime);

            // Extract refresh information using helper
            if PowerBIJsonProcessor.ExtractRefreshInfo(JObject, RefreshType, Status, StartTime, EndTime) then begin
                RefreshCount += 1;

                // Update latest refresh info on first iteration (most recent)
                if RefreshCount = 1 then
                    UpdateLatestDataflowRefresh(PowerBIDataflow, Status, StartTime, EndTime);

                // Calculate duration and add to total
                if EndTime <> 0DT then begin
                    DurationMinutes := PowerBIJsonProcessor.CalculateDurationMinutes(StartTime, EndTime);
                    TotalDuration += DurationMinutes;
                end;
            end;
        end;

        // Calculate and update averages
        if RefreshCount > 0 then
            UpdateDataflowRefreshStatistics(PowerBIDataflow, TotalDuration, RefreshCount);

        PowerBIDataflow.Modify();
    end;

    local procedure UpdateLatestDataflowRefresh(var PowerBIDataflow: Record "Power BI Dataflow"; Status: Text; StartTime: DateTime; EndTime: DateTime)
    var
        DurationMinutes: Decimal;
    begin
        PowerBIDataflow."Last Refresh" := StartTime;
        PowerBIDataflow."Last Refresh Status" := CopyStr(Status, 1, MaxStrLen(PowerBIDataflow."Last Refresh Status"));

        if EndTime <> 0DT then begin
            DurationMinutes := PowerBIJsonProcessor.CalculateDurationMinutes(StartTime, EndTime);
            PowerBIDataflow."Last Refresh Duration (Min)" := DurationMinutes;
        end;
    end;

    local procedure UpdateDataflowRefreshStatistics(var PowerBIDataflow: Record "Power BI Dataflow"; TotalDuration: Decimal; RefreshCount: Integer)
    begin
        if RefreshCount > 0 then begin
            PowerBIDataflow."Average Refresh Duration (Min)" := TotalDuration / RefreshCount;
            PowerBIDataflow."Refresh Count" := RefreshCount;
        end;
    end;
}