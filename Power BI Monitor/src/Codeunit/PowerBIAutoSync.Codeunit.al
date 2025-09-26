codeunit 90111 "Power BI Auto Sync"
{
    // This codeunit handles automatic synchronization of Power BI data
    // It's designed to be called by job queue entries

    trigger OnRun()
    begin
        RunAutoSync();
    end;

    procedure RunAutoSync()
    var
        PowerBISetup: Record "Power BI Setup";
        PowerBIAPIOrchestrator: Codeunit "Power BI API Orchestrator";
        SyncSuccessful: Boolean;
    begin
        // Get setup record
        if not PowerBISetup.Get('') then
            exit;

        // Check if auto sync is enabled
        if not PowerBISetup."Auto Sync Enabled" then
            exit;

        // Check if sync is due
        if not IsSyncDue(PowerBISetup) then
            exit;

        // Run synchronization
        SyncSuccessful := false;
        if PowerBIAPIOrchestrator.SynchronizeAllData() then begin
            SyncSuccessful := true;

            // Update last sync time
            PowerBISetup."Last Auto Sync" := CurrentDateTime();
            PowerBISetup.Modify();
        end;

        // Log the sync attempt
        LogSyncAttempt(SyncSuccessful);
    end;

    procedure IsSyncDue(PowerBISetup: Record "Power BI Setup"): Boolean
    var
        HoursSinceLastSync: Decimal;
        SyncFrequencyHours: Integer;
    begin
        // If never synced before, sync now
        if PowerBISetup."Last Auto Sync" = 0DT then
            exit(true);

        // Calculate hours since last sync
        HoursSinceLastSync := (CurrentDateTime() - PowerBISetup."Last Auto Sync") / (1000 * 60 * 60); // Convert milliseconds to hours

        // Get sync frequency (default to 24 hours if not set)
        SyncFrequencyHours := PowerBISetup."Sync Frequency (Hours)";
        if SyncFrequencyHours <= 0 then
            SyncFrequencyHours := 24;

        // Check if it's time to sync
        exit(HoursSinceLastSync >= SyncFrequencyHours);
    end;

    procedure CreateJobQueueEntry(): Boolean
    var
        JobQueueEntry: Record "Job Queue Entry";
        PowerBISetup: Record "Power BI Setup";
    begin
        // Get setup to determine frequency
        if not PowerBISetup.Get('') then
            exit(false);

        // Delete existing job queue entry if it exists
        DeleteJobQueueEntry();

        // Create new job queue entry
        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::"Power BI Auto Sync";
        JobQueueEntry."Job Queue Category Code" := 'POWERBI';
        JobQueueEntry.Description := 'Power BI Auto Synchronization';
        JobQueueEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(JobQueueEntry."User ID"));

        // Set to run every hour (we'll check internally if sync is actually due)
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;
        JobQueueEntry."Run on Saturdays" := true;
        JobQueueEntry."Run on Sundays" := true;
        JobQueueEntry."Starting Time" := Time();
        JobQueueEntry."No. of Minutes between Runs" := 60; // Check every hour

        // Insert and set to ready
        if JobQueueEntry.Insert(true) then begin
            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
            exit(true);
        end;

        exit(false);
    end;

    procedure DeleteJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Power BI Auto Sync");
        if JobQueueEntry.FindSet() then
            repeat
                JobQueueEntry.Cancel();
                JobQueueEntry.Delete();
            until JobQueueEntry.Next() = 0;
    end;

    procedure IsJobQueueEntryActive(): Boolean
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Power BI Auto Sync");
        JobQueueEntry.SetFilter(Status, '%1|%2', JobQueueEntry.Status::Ready, JobQueueEntry.Status::"In Process");
        exit(not JobQueueEntry.IsEmpty());
    end;

    local procedure LogSyncAttempt(Success: Boolean)
    begin
        // Optional: Add logging logic here if needed
        // For now, we'll just use the Last Auto Sync field in the setup table
        // The Success parameter can be used for future logging implementation
        if Success then
            exit; // Placeholder for success logging
    end;
}