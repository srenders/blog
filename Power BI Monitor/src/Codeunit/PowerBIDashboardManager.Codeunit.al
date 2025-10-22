codeunit 90136 "Power BI Dashboard Manager"
{
    // Specialized management for Power BI dashboards

    var
        PowerBIHttpClient: Codeunit "Power BI Http Client";
        PowerBIJsonProcessor: Codeunit "Power BI Json Processor";

    /// <summary>
    /// Synchronizes dashboards for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to sync dashboards for</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeDashboards(WorkspaceId: Guid): Boolean
    var
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
    begin
        // Build API URL for dashboards
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(WorkspaceId, 'dashboards');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Process dashboards
        ProcessDashboards(WorkspaceId, JsonArray);
        exit(true);
    end;

    /// <summary>
    /// Synchronizes all dashboards across all workspaces
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeAllDashboards(): Boolean
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
            if SynchronizeDashboards(WorkspaceRec."Workspace ID") then
                SuccessCount += 1;
        until WorkspaceRec.Next() = 0;

        // Message('Synchronized dashboards for %1 of %2 workspaces', SuccessCount, TotalCount);
        exit(SuccessCount > 0);
    end;

    /// <summary>
    /// Processes dashboard data from Power BI API response
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID these dashboards belong to</param>
    /// <param name="JsonArray">Array of dashboard objects from API</param>
    local procedure ProcessDashboards(WorkspaceId: Guid; JsonArray: JsonArray)
    var
        DashboardRec: Record "Power BI Dashboard";
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
            if StoreDashboard(WorkspaceId, JObject, DashboardRec) then
                Counter += 1;
        end;
        // Message('Successfully processed %1 dashboards for workspace', Counter);
    end;

    /// <summary>
    /// Stores a single dashboard from JSON data
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID this dashboard belongs to</param>
    /// <param name="JsonObj">JSON object containing dashboard data</param>
    /// <param name="DashboardRec">Dashboard record to populate</param>
    /// <returns>True if dashboard was stored successfully</returns>
    local procedure StoreDashboard(WorkspaceId: Guid; JsonObj: JsonObject; var DashboardRec: Record "Power BI Dashboard"): Boolean
    var
        DashboardId: Guid;
        DashboardName: Text[100];
        DisplayName: Text[100];
        EmbedUrl: Text[250];
        WebUrl: Text[250];
        IsReadOnly: Boolean;
    begin
        // Extract basic information
        DashboardId := PowerBIJsonProcessor.GetGuidValue(JsonObj, 'id');
        if IsNullGuid(DashboardId) then
            exit(false);

        DashboardName := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'name', ''), 1, MaxStrLen(DashboardName));
        DisplayName := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'displayName', DashboardName), 1, MaxStrLen(DisplayName));
        EmbedUrl := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'embedUrl', ''), 1, MaxStrLen(EmbedUrl));
        WebUrl := CopyStr(PowerBIJsonProcessor.GetTextValue(JsonObj, 'webUrl', ''), 1, MaxStrLen(WebUrl));
        IsReadOnly := PowerBIJsonProcessor.GetBooleanValue(JsonObj, 'isReadOnly', false);

        // Find or create dashboard record
        DashboardRec.SetRange("Dashboard ID", DashboardId);
        if not DashboardRec.FindFirst() then begin
            // Insert new dashboard
            DashboardRec.Init();
            DashboardRec."Dashboard ID" := DashboardId;
            DashboardRec."Workspace ID" := WorkspaceId;
            DashboardRec."Dashboard Name" := DashboardName;
            DashboardRec."Display Name" := DisplayName;
            DashboardRec."Embed URL" := EmbedUrl;
            DashboardRec."Web URL" := WebUrl;
            DashboardRec."Is ReadOnly" := IsReadOnly;
            DashboardRec."Last Sync Date" := CurrentDateTime();
            DashboardRec.Insert(false);
        end else begin
            // Update existing dashboard
            DashboardRec."Workspace ID" := WorkspaceId;
            DashboardRec."Dashboard Name" := DashboardName;
            DashboardRec."Display Name" := DisplayName;
            DashboardRec."Embed URL" := EmbedUrl;
            DashboardRec."Web URL" := WebUrl;
            DashboardRec."Is ReadOnly" := IsReadOnly;
            DashboardRec."Last Sync Date" := CurrentDateTime();
            DashboardRec.Modify(false);
        end;

        exit(true);
    end;

    /// <summary>
    /// Gets dashboard tiles and updates tile count
    /// </summary>
    /// <param name="DashboardId">The dashboard ID to get tiles for</param>
    /// <returns>True if tiles were retrieved successfully</returns>
    procedure GetDashboardTiles(DashboardId: Guid): Boolean
    var
        DashboardRec: Record "Power BI Dashboard";
        ResponseText: Text;
        JsonArray: JsonArray;
        EndpointUrl: Text;
        TileCount: Integer;
    begin
        // Get dashboard record to find workspace
        DashboardRec.SetRange("Dashboard ID", DashboardId);
        if not DashboardRec.FindFirst() then
            exit(false);

        // Build API URL for dashboard tiles
        EndpointUrl := PowerBIHttpClient.BuildWorkspaceApiUrl(DashboardRec."Workspace ID",
            'dashboards/' + Format(DashboardId) + '/tiles');

        // Execute request
        if not PowerBIHttpClient.ExecuteGetRequest(EndpointUrl, ResponseText) then
            exit(false);

        // Validate and parse response
        if not PowerBIHttpClient.ValidateJsonArrayResponse(ResponseText, JsonArray) then
            exit(false);

        // Update tile count
        TileCount := JsonArray.Count();
        DashboardRec."Tile Count" := TileCount;
        DashboardRec."Last Sync Date" := CurrentDateTime();
        DashboardRec.Modify(true);

        exit(true);
    end;

    /// <summary>
    /// Gets dashboard information by ID
    /// </summary>
    /// <param name="DashboardId">The dashboard ID to retrieve</param>
    /// <param name="DashboardRec">The dashboard record to populate</param>
    /// <returns>True if dashboard was found</returns>
    procedure GetDashboard(DashboardId: Guid; var DashboardRec: Record "Power BI Dashboard"): Boolean
    begin
        DashboardRec.SetRange("Dashboard ID", DashboardId);
        exit(DashboardRec.FindFirst());
    end;

    /// <summary>
    /// Validates if a dashboard exists and belongs to an active workspace
    /// </summary>
    /// <param name="DashboardId">The dashboard ID to validate</param>
    /// <returns>True if dashboard is valid and accessible</returns>
    procedure ValidateDashboard(DashboardId: Guid): Boolean
    var
        DashboardRec: Record "Power BI Dashboard";
        WorkspaceRec: Record "Power BI Workspace";
    begin
        DashboardRec.SetRange("Dashboard ID", DashboardId);
        if not DashboardRec.FindFirst() then
            exit(false);

        // Check if workspace is enabled for sync
        WorkspaceRec.SetRange("Workspace ID", DashboardRec."Workspace ID");
        if not WorkspaceRec.FindFirst() then
            exit(false);

        exit(WorkspaceRec."Sync Enabled");
    end;
}