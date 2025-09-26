codeunit 90134 "Power BI Workspace Manager"
{
    // Specialized management for Power BI workspaces

    var
        PowerBIHttpClient: Codeunit "Power BI Http Client";
        PowerBIJsonProcessor: Codeunit "Power BI Json Processor";

    /// <summary>
    /// Synchronizes all workspaces from Power BI service
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
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

    /// <summary>
    /// Processes workspace data from Power BI API response
    /// </summary>
    /// <param name="JsonArray">Array of workspace objects from API</param>
    local procedure ProcessWorkspaces(JsonArray: JsonArray)
    var
        WorkspaceRec: Record "Power BI Workspace";
        JToken: JsonToken;
        JObject: JsonObject;
        Counter: Integer;
    begin
        Counter := 0;
        foreach JToken in JsonArray do begin
            JObject := JToken.AsObject();
            if StoreWorkspace(JObject, WorkspaceRec) then
                Counter += 1;
        end;
        Message('Successfully processed %1 workspaces', Counter);
    end;

    /// <summary>
    /// Stores a single workspace from JSON data
    /// </summary>
    /// <param name="JsonObj">JSON object containing workspace data</param>
    /// <param name="WorkspaceRec">Workspace record to populate</param>
    /// <returns>True if workspace was stored successfully</returns>
    local procedure StoreWorkspace(JsonObj: JsonObject; var WorkspaceRec: Record "Power BI Workspace"): Boolean
    var
        WorkspaceId: Guid;
        WorkspaceName: Text[100];
        WorkspaceType: Text[50];
        IsReadOnly: Boolean;
    begin
        // Extract basic information
        WorkspaceId := PowerBIJsonProcessor.GetGuidValue(JsonObj, 'id');
        if IsNullGuid(WorkspaceId) then
            exit(false);

        WorkspaceName := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'name', ''), 1, MaxStrLen(WorkspaceName));
        WorkspaceType := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'type', 'Workspace'), 1, MaxStrLen(WorkspaceType));
        IsReadOnly := PowerBIJsonProcessor.GetBooleanValue(JsonObj, 'isReadOnly', false);

        // Find or create workspace record
        if not WorkspaceRec.Get(WorkspaceId) then begin
            WorkspaceRec.Init();
            WorkspaceRec."Workspace ID" := WorkspaceId;
        end;

        // Update workspace information
        WorkspaceRec."Workspace Name" := WorkspaceName;
        WorkspaceRec."Workspace Type" := WorkspaceType;
        WorkspaceRec."Is Read Only" := IsReadOnly;
        WorkspaceRec."Last Synchronized" := CurrentDateTime();
        WorkspaceRec."Sync Enabled" := true;

        // Save record
        if WorkspaceRec."Workspace ID" = WorkspaceId then
            WorkspaceRec.Modify(true)
        else
            WorkspaceRec.Insert(true);

        exit(true);
    end;

    /// <summary>
    /// Gets workspace information by ID
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to retrieve</param>
    /// <param name="WorkspaceRec">The workspace record to populate</param>
    /// <returns>True if workspace was found</returns>
    procedure GetWorkspace(WorkspaceId: Guid; var WorkspaceRec: Record "Power BI Workspace"): Boolean
    begin
        exit(WorkspaceRec.Get(WorkspaceId));
    end;

    /// <summary>
    /// Validates if a workspace exists and is accessible
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to validate</param>
    /// <returns>True if workspace is valid and accessible</returns>
    procedure ValidateWorkspace(WorkspaceId: Guid): Boolean
    var
        WorkspaceRec: Record "Power BI Workspace";
    begin
        if not WorkspaceRec.Get(WorkspaceId) then
            exit(false);

        // Check if workspace is enabled for sync
        exit(WorkspaceRec."Sync Enabled");
    end;
}