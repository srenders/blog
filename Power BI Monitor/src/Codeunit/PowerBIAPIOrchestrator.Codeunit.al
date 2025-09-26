codeunit 90120 "Power BI API Orchestrator"
{
    // Clean orchestrator for Power BI API operations using specialized managers
    Permissions = tabledata "Power BI Setup" = R,
                  tabledata "Power BI Workspace" = RIMD,
                  tabledata "Power BI Dataset" = RIMD,
                  tabledata "Power BI Dataflow" = RIMD,
                  tabledata "Power BI Dashboard" = RIMD,
                  tabledata "Power BI Report" = RIMD;

    var
        PowerBIWorkspaceManager: Codeunit "Power BI Workspace Manager";
        PowerBIDatasetManager: Codeunit "Power BI Dataset Manager";
        PowerBIDataflowManager: Codeunit "Power BI Dataflow Manager";
        PowerBIDashboardManager: Codeunit "Power BI Dashboard Manager";
        PowerBIReportManager: Codeunit "Power BI Report Manager";

    // =======================
    // WORKSPACE OPERATIONS
    // =======================

    /// <summary>
    /// Synchronizes all workspaces from Power BI service
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeWorkspaces(): Boolean
    begin
        exit(PowerBIWorkspaceManager.SynchronizeWorkspaces());
    end;

    // =======================
    // DATASET OPERATIONS
    // =======================

    /// <summary>
    /// Synchronizes datasets for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to sync datasets for</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeDatasets(WorkspaceId: Guid): Boolean
    begin
        exit(PowerBIDatasetManager.SynchronizeDatasets(WorkspaceId));
    end;

    /// <summary>
    /// Gets refresh history for a specific dataset
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DatasetId">The dataset ID</param>
    /// <returns>True if refresh history was retrieved</returns>
    procedure GetDatasetRefreshHistory(WorkspaceId: Guid; DatasetId: Guid): Boolean
    begin
        exit(PowerBIDatasetManager.GetDatasetRefreshHistory(WorkspaceId, DatasetId));
    end;

    /// <summary>
    /// Triggers a refresh for a specific dataset
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DatasetId">The dataset ID</param>
    /// <returns>True if refresh was triggered</returns>
    procedure TriggerDatasetRefresh(WorkspaceId: Guid; DatasetId: Guid): Boolean
    begin
        exit(PowerBIDatasetManager.TriggerDatasetRefresh(WorkspaceId, DatasetId));
    end;

    // =======================
    // DATAFLOW OPERATIONS
    // =======================

    /// <summary>
    /// Synchronizes dataflows for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to sync dataflows for</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeDataflows(WorkspaceId: Guid): Boolean
    begin
        exit(PowerBIDataflowManager.SynchronizeDataflows(WorkspaceId));
    end;

    /// <summary>
    /// Synchronizes all dataflows across all workspaces
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeAllDataflows(): Boolean
    begin
        exit(PowerBIDataflowManager.SynchronizeAllDataflows());
    end;

    /// <summary>
    /// Triggers a refresh for a specific dataflow
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DataflowId">The dataflow ID to refresh</param>
    /// <returns>True if refresh was triggered successfully</returns>
    procedure TriggerDataflowRefresh(WorkspaceId: Guid; DataflowId: Guid): Boolean
    begin
        exit(PowerBIDataflowManager.TriggerDataflowRefresh(WorkspaceId, DataflowId));
    end;

    /// <summary>
    /// Gets refresh history for a specific dataflow
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID</param>
    /// <param name="DataflowId">The dataflow ID to get refresh history for</param>
    /// <returns>True if refresh history was retrieved successfully</returns>
    procedure GetDataflowRefreshHistory(WorkspaceId: Guid; DataflowId: Guid): Boolean
    begin
        exit(PowerBIDataflowManager.GetDataflowRefreshHistory(WorkspaceId, DataflowId));
    end;

    // =======================
    // DASHBOARD OPERATIONS
    // =======================

    /// <summary>
    /// Synchronizes dashboards for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to sync dashboards for</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeDashboards(WorkspaceId: Guid): Boolean
    begin
        exit(PowerBIDashboardManager.SynchronizeDashboards(WorkspaceId));
    end;

    /// <summary>
    /// Synchronizes all dashboards across all workspaces
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeAllDashboards(): Boolean
    begin
        exit(PowerBIDashboardManager.SynchronizeAllDashboards());
    end;

    /// <summary>
    /// Gets dashboard tiles and updates tile count
    /// </summary>
    /// <param name="DashboardId">The dashboard ID to get tiles for</param>
    /// <returns>True if tiles were retrieved successfully</returns>
    procedure GetDashboardTiles(DashboardId: Guid): Boolean
    begin
        exit(PowerBIDashboardManager.GetDashboardTiles(DashboardId));
    end;

    // =======================
    // REPORT OPERATIONS
    // =======================

    /// <summary>
    /// Synchronizes reports for a specific workspace
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to sync reports for</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeReports(WorkspaceId: Guid): Boolean
    begin
        exit(PowerBIReportManager.SynchronizeReports(WorkspaceId));
    end;

    /// <summary>
    /// Synchronizes all reports across all workspaces
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeAllReports(): Boolean
    begin
        exit(PowerBIReportManager.SynchronizeAllReports());
    end;

    /// <summary>
    /// Legacy alias for SynchronizeAllReports - for backward compatibility
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeReports(): Boolean
    begin
        exit(SynchronizeAllReports());
    end;

    /// <summary>
    /// Synchronizes reports for a specific workspace - alias for SynchronizeReports
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to sync reports for</param>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeReportsForWorkspace(WorkspaceId: Guid): Boolean
    begin
        exit(PowerBIReportManager.SynchronizeReports(WorkspaceId));
    end;

    // =======================
    // ORCHESTRATION OPERATIONS
    // =======================

    /// <summary>
    /// Synchronizes all Power BI resources (workspaces, datasets, dataflows, dashboards, reports)
    /// </summary>
    /// <returns>True if all synchronizations were successful</returns>
    procedure SynchronizeAllData(): Boolean
    var
        WorkspacesSuccess: Boolean;
        DatasetsSuccess: Boolean;
        DataflowsSuccess: Boolean;
        DashboardsSuccess: Boolean;
        ReportsSuccess: Boolean;
        SuccessCount: Integer;
    begin
        // Synchronize in order of dependency
        WorkspacesSuccess := SynchronizeWorkspaces();
        if WorkspacesSuccess then SuccessCount += 1;

        DatasetsSuccess := SynchronizeAllDatasets();
        if DatasetsSuccess then SuccessCount += 1;

        DataflowsSuccess := SynchronizeAllDataflows();
        if DataflowsSuccess then SuccessCount += 1;

        DashboardsSuccess := SynchronizeAllDashboards();
        if DashboardsSuccess then SuccessCount += 1;

        ReportsSuccess := SynchronizeAllReports();
        if ReportsSuccess then SuccessCount += 1;

        // Report results
        Message('Synchronization Results:\nWorkspaces: %1\nDatasets: %2\nDataflows: %3\nDashboards: %4\nReports: %5\n\nTotal Success: %6/5',
            Format(WorkspacesSuccess), Format(DatasetsSuccess), Format(DataflowsSuccess),
            Format(DashboardsSuccess), Format(ReportsSuccess), SuccessCount);

        // Return true if at least workspaces succeeded (minimum requirement)
        exit(WorkspacesSuccess);
    end;

    /// <summary>
    /// Synchronizes all datasets across all workspaces
    /// </summary>
    /// <returns>True if synchronization was successful</returns>
    procedure SynchronizeAllDatasets(): Boolean
    var
        WorkspaceRec: Record "Power BI Workspace";
        SuccessCount: Integer;
        TotalCount: Integer;
    begin
        WorkspaceRec.SetRange("Sync Enabled", true);
        if not WorkspaceRec.FindSet() then begin
            Message('No workspaces found for dataset synchronization');
            exit(true);
        end;

        repeat
            TotalCount += 1;
            if SynchronizeDatasets(WorkspaceRec."Workspace ID") then
                SuccessCount += 1;
        until WorkspaceRec.Next() = 0;

        Message('Synchronized datasets for %1 of %2 workspaces', SuccessCount, TotalCount);
        exit(SuccessCount > 0);
    end;

    // =======================
    // VALIDATION OPERATIONS
    // =======================

    /// <summary>
    /// Validates if a workspace exists and is accessible
    /// </summary>
    /// <param name="WorkspaceId">The workspace ID to validate</param>
    /// <returns>True if workspace is valid and accessible</returns>
    procedure ValidateWorkspace(WorkspaceId: Guid): Boolean
    begin
        exit(PowerBIWorkspaceManager.ValidateWorkspace(WorkspaceId));
    end;

    /// <summary>
    /// Validates if a dataflow exists and is accessible
    /// </summary>
    /// <param name="DataflowId">The dataflow ID to validate</param>
    /// <returns>True if dataflow is valid and accessible</returns>
    procedure ValidateDataflow(DataflowId: Guid): Boolean
    begin
        exit(PowerBIDataflowManager.ValidateDataflow(DataflowId));
    end;

    /// <summary>
    /// Validates if a dashboard exists and is accessible
    /// </summary>
    /// <param name="DashboardId">The dashboard ID to validate</param>
    /// <returns>True if dashboard is valid and accessible</returns>
    procedure ValidateDashboard(DashboardId: Guid): Boolean
    begin
        exit(PowerBIDashboardManager.ValidateDashboard(DashboardId));
    end;

    /// <summary>
    /// Validates if a report exists and is accessible
    /// </summary>
    /// <param name="ReportId">The report ID to validate</param>
    /// <returns>True if report is valid and accessible</returns>
    procedure ValidateReport(ReportId: Guid): Boolean
    begin
        exit(PowerBIReportManager.ValidateReport(ReportId));
    end;
}