codeunit 90132 "Power BI Json Processor"
{
    // JSON processing utilities for Power BI API responses

    /// <summary>
    /// Extracts a text value from a JSON object
    /// </summary>
    /// <param name="JsonObject">The JSON object to extract from</param>
    /// <param name="PropertyName">The property name to extract</param>
    /// <param name="DefaultValue">Default value if property not found</param>
    /// <returns>The extracted text value or default</returns>
    procedure GetTextValue(JsonObject: JsonObject; PropertyName: Text; DefaultValue: Text): Text
    var
        JToken: JsonToken;
    begin
        if JsonObject.Get(PropertyName, JToken) then
            exit(JToken.AsValue().AsText());
        exit(DefaultValue);
    end;

    /// <summary>
    /// Extracts a GUID value from a JSON object
    /// </summary>
    /// <param name="JsonObject">The JSON object to extract from</param>
    /// <param name="PropertyName">The property name to extract</param>
    /// <returns>The extracted GUID value or null GUID</returns>
    procedure GetGuidValue(JsonObject: JsonObject; PropertyName: Text): Guid
    var
        JToken: JsonToken;
        GuidText: Text;
    begin
        if JsonObject.Get(PropertyName, JToken) then begin
            GuidText := JToken.AsValue().AsText();
            if GuidText <> '' then
                exit(GuidText);
        end;
        exit(CreateGuid()); // Return null GUID equivalent
    end;

    /// <summary>
    /// Extracts a boolean value from a JSON object
    /// </summary>
    /// <param name="JsonObject">The JSON object to extract from</param>
    /// <param name="PropertyName">The property name to extract</param>
    /// <param name="DefaultValue">Default value if property not found</param>
    /// <returns>The extracted boolean value or default</returns>
    procedure GetBooleanValue(JsonObject: JsonObject; PropertyName: Text; DefaultValue: Boolean): Boolean
    var
        JToken: JsonToken;
    begin
        if JsonObject.Get(PropertyName, JToken) then
            exit(JToken.AsValue().AsBoolean());
        exit(DefaultValue);
    end;

    /// <summary>
    /// Extracts a DateTime value from a JSON object
    /// </summary>
    /// <param name="JsonObject">The JSON object to extract from</param>
    /// <param name="PropertyName">The property name to extract</param>
    /// <returns>The extracted DateTime value or blank DateTime</returns>
    procedure GetDateTimeValue(JsonObject: JsonObject; PropertyName: Text): DateTime
    var
        JToken: JsonToken;
    begin
        if JsonObject.Get(PropertyName, JToken) then
            exit(JToken.AsValue().AsDateTime());
        exit(0DT);
    end;

    /// <summary>
    /// Extracts a decimal value from a JSON object
    /// </summary>
    /// <param name="JsonObject">The JSON object to extract from</param>
    /// <param name="PropertyName">The property name to extract</param>
    /// <param name="DefaultValue">Default value if property not found</param>
    /// <returns>The extracted decimal value or default</returns>
    procedure GetDecimalValue(JsonObject: JsonObject; PropertyName: Text; DefaultValue: Decimal): Decimal
    var
        JToken: JsonToken;
    begin
        if JsonObject.Get(PropertyName, JToken) then
            exit(JToken.AsValue().AsDecimal());
        exit(DefaultValue);
    end;

    /// <summary>
    /// Safely copies text to a field with length validation
    /// </summary>
    /// <param name="SourceText">The source text to copy</param>
    /// <param name="MaxLength">Maximum allowed length</param>
    /// <returns>Truncated text that fits the field</returns>
    procedure SafeCopyText(SourceText: Text; MaxLength: Integer): Text
    begin
        if SourceText = '' then
            exit('');
        exit(CopyStr(SourceText, 1, MaxLength));
    end;

    /// <summary>
    /// Calculates duration in minutes from start and end times
    /// </summary>
    /// <param name="StartTime">The start time</param>
    /// <param name="EndTime">The end time</param>
    /// <returns>Duration in minutes</returns>
    procedure CalculateDurationMinutes(StartTime: DateTime; EndTime: DateTime): Decimal
    begin
        if (StartTime = 0DT) or (EndTime = 0DT) then
            exit(0);
        if EndTime <= StartTime then
            exit(0);
        exit((EndTime - StartTime) / 60000); // Convert milliseconds to minutes
    end;

    /// <summary>
    /// Checks if a property exists in a JSON object
    /// </summary>
    /// <param name="JsonObject">The JSON object to check</param>
    /// <param name="PropertyName">The property name to look for</param>
    /// <returns>True if property exists</returns>
    procedure HasProperty(JsonObject: JsonObject; PropertyName: Text): Boolean
    var
        JToken: JsonToken;
    begin
        exit(JsonObject.Get(PropertyName, JToken));
    end;

    /// <summary>
    /// Extracts workspace information from JSON object
    /// </summary>
    /// <param name="JsonObject">The workspace JSON object</param>
    /// <param name="WorkspaceId">Extracted workspace ID</param>
    /// <param name="WorkspaceName">Extracted workspace name</param>
    /// <param name="WorkspaceType">Extracted workspace type</param>
    /// <param name="IsReadOnly">Extracted read-only flag</param>
    /// <returns>True if required fields were found</returns>
    procedure ExtractWorkspaceInfo(JsonObject: JsonObject; var WorkspaceId: Guid; var WorkspaceName: Text; var WorkspaceType: Text; var IsReadOnly: Boolean): Boolean
    begin
        // Check required fields
        if not HasProperty(JsonObject, 'id') or not HasProperty(JsonObject, 'name') then
            exit(false);

        WorkspaceId := GetGuidValue(JsonObject, 'id');
        WorkspaceName := GetTextValue(JsonObject, 'name', '');
        WorkspaceType := GetTextValue(JsonObject, 'type', '');
        IsReadOnly := GetBooleanValue(JsonObject, 'isReadOnly', false);

        exit(true);
    end;

    /// <summary>
    /// Extracts dataset information from JSON object
    /// </summary>
    /// <param name="JsonObject">The dataset JSON object</param>
    /// <param name="DatasetId">Extracted dataset ID</param>
    /// <param name="DatasetName">Extracted dataset name</param>
    /// <param name="WebUrl">Extracted web URL</param>
    /// <param name="ConfiguredBy">Extracted configured by</param>
    /// <param name="IsRefreshable">Extracted refreshable flag</param>
    /// <returns>True if required fields were found</returns>
    procedure ExtractDatasetInfo(JsonObject: JsonObject; var DatasetId: Guid; var DatasetName: Text; var WebUrl: Text; var ConfiguredBy: Text; var IsRefreshable: Boolean): Boolean
    begin
        // Check required fields
        if not HasProperty(JsonObject, 'id') or not HasProperty(JsonObject, 'name') then
            exit(false);

        DatasetId := GetGuidValue(JsonObject, 'id');
        DatasetName := GetTextValue(JsonObject, 'name', '');
        WebUrl := GetTextValue(JsonObject, 'webUrl', '');
        ConfiguredBy := GetTextValue(JsonObject, 'configuredBy', '');
        IsRefreshable := GetBooleanValue(JsonObject, 'isRefreshable', false);

        exit(true);
    end;

    /// <summary>
    /// Extracts dataflow information from JSON object
    /// </summary>
    /// <param name="JsonObject">The dataflow JSON object</param>
    /// <param name="DataflowId">Extracted dataflow ID</param>
    /// <param name="DataflowName">Extracted dataflow name</param>
    /// <param name="Description">Extracted description</param>
    /// <param name="ConfiguredBy">Extracted configured by</param>
    /// <returns>True if required fields were found</returns>
    procedure ExtractDataflowInfo(JsonObject: JsonObject; var DataflowId: Guid; var DataflowName: Text; var Description: Text; var ConfiguredBy: Text): Boolean
    begin
        // Check required fields (dataflows use 'objectId' instead of 'id')
        if not HasProperty(JsonObject, 'objectId') or not HasProperty(JsonObject, 'name') then
            exit(false);

        DataflowId := GetGuidValue(JsonObject, 'objectId');
        DataflowName := GetTextValue(JsonObject, 'name', '');
        Description := GetTextValue(JsonObject, 'description', '');
        ConfiguredBy := GetTextValue(JsonObject, 'configuredBy', '');

        exit(true);
    end;

    /// <summary>
    /// Extracts report information from JSON object
    /// </summary>
    /// <param name="JsonObject">The report JSON object</param>
    /// <param name="ReportId">Extracted report ID</param>
    /// <param name="ReportName">Extracted report name</param>
    /// <param name="WebUrl">Extracted web URL</param>
    /// <param name="DatasetId">Extracted dataset ID</param>
    /// <param name="ReportType">Extracted report type</param>
    /// <returns>True if required fields were found</returns>
    procedure ExtractReportInfo(JsonObject: JsonObject; var ReportId: Guid; var ReportName: Text; var WebUrl: Text; var DatasetId: Guid; var ReportType: Text): Boolean
    begin
        // Check required fields
        if not HasProperty(JsonObject, 'id') or not HasProperty(JsonObject, 'name') then
            exit(false);

        ReportId := GetGuidValue(JsonObject, 'id');
        ReportName := GetTextValue(JsonObject, 'name', '');
        WebUrl := GetTextValue(JsonObject, 'webUrl', '');
        DatasetId := GetGuidValue(JsonObject, 'datasetId');
        ReportType := GetTextValue(JsonObject, 'reportType', '');

        exit(true);
    end;

    /// <summary>
    /// Extracts refresh history information from JSON object
    /// </summary>
    /// <param name="JsonObject">The refresh history JSON object</param>
    /// <param name="RefreshType">Extracted refresh type</param>
    /// <param name="Status">Extracted status</param>
    /// <param name="StartTime">Extracted start time</param>
    /// <param name="EndTime">Extracted end time</param>
    /// <returns>True if required fields were found</returns>
    procedure ExtractRefreshInfo(JsonObject: JsonObject; var RefreshType: Text; var Status: Text; var StartTime: DateTime; var EndTime: DateTime): Boolean
    begin
        // Check required fields
        if not HasProperty(JsonObject, 'status') or not HasProperty(JsonObject, 'startTime') then
            exit(false);

        RefreshType := GetTextValue(JsonObject, 'refreshType', '');
        Status := GetTextValue(JsonObject, 'status', '');
        StartTime := GetDateTimeValue(JsonObject, 'startTime');
        EndTime := GetDateTimeValue(JsonObject, 'endTime');

        exit(true);
    end;

    /// <summary>
    /// Builds a dataflow web URL since the API doesn't provide it
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DataflowId">The dataflow ID</param>
    /// <returns>The constructed web URL</returns>
    procedure BuildDataflowWebUrl(WorkspaceId: Guid; DataflowId: Guid): Text
    var
        PowerBIHttpClient: Codeunit "Power BI Http Client";
    begin
        exit('https://app.powerbi.com/groups/' +
             PowerBIHttpClient.FormatGuidForUrl(WorkspaceId) +
             '/dataflows/' +
             PowerBIHttpClient.FormatGuidForUrl(DataflowId));
    end;
}