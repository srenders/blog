table 90112 "Power BI Setup"
{
    Caption = 'Power BI Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        field(2; "Client ID"; Text[100])
        {
            Caption = 'Client ID';
            ToolTip = 'Specifies the Azure AD Application (Client) ID for Power BI API access.';
        }

        field(3; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            ExtendedDatatype = Masked;
            ToolTip = 'Specifies the Azure AD Application Client Secret for Power BI API access.';
        }

        field(4; "Tenant ID"; Text[100])
        {
            Caption = 'Tenant ID';
            ToolTip = 'Specifies the Azure AD Tenant ID for authentication.';
        }

        field(5; "Authority URL"; Text[250])
        {
            Caption = 'Authority URL';
            ToolTip = 'Specifies the Azure AD authority URL for authentication.';
        }

        field(6; "Power BI API URL"; Text[250])
        {
            Caption = 'Power BI API URL';
            ToolTip = 'Specifies the Power BI REST API base URL.';
        }

        field(7; "Auto Sync Enabled"; Boolean)
        {
            Caption = 'Auto Sync Enabled';
            ToolTip = 'Specifies whether automatic synchronization is enabled.';

            trigger OnValidate()
            var
                PowerBIAutoSync: Codeunit "Power BI Auto Sync";
            begin
                if "Auto Sync Enabled" then begin
                    // When enabling auto sync, create job queue entry if it doesn't exist
                    if not PowerBIAutoSync.IsJobQueueEntryActive() then
                        if not PowerBIAutoSync.CreateJobQueueEntry() then
                            Error('Failed to create job queue entry for automatic synchronization.');
                end else
                    // When disabling auto sync, remove job queue entry
                    if PowerBIAutoSync.IsJobQueueEntryActive() then
                        PowerBIAutoSync.DeleteJobQueueEntry();
            end;
        }

        field(8; "Sync Frequency (Hours)"; Integer)
        {
            Caption = 'Sync Frequency (Hours)';
            ToolTip = 'Specifies how often to automatically sync data from Power BI (in hours).';
            MinValue = 1;
            MaxValue = 168; // 7 days

            trigger OnValidate()
            var
                PowerBIAutoSync: Codeunit "Power BI Auto Sync";
            begin
                // If auto sync is enabled and frequency changed, recreate job queue entry
                if "Auto Sync Enabled" and PowerBIAutoSync.IsJobQueueEntryActive() then begin
                    PowerBIAutoSync.DeleteJobQueueEntry();
                    if not PowerBIAutoSync.CreateJobQueueEntry() then
                        Error('Failed to update job queue entry with new frequency.');
                end;
            end;
        }

        field(9; "Last Auto Sync"; DateTime)
        {
            Caption = 'Last Auto Sync';
            ToolTip = 'Specifies when the last automatic sync was performed.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        SetDefaults();
    end;

    local procedure SetDefaults()
    begin
        "Primary Key" := '';
        "Authority URL" := 'https://login.microsoftonline.com/';
        "Power BI API URL" := 'https://api.powerbi.com/v1.0/myorg/';
        "Sync Frequency (Hours)" := 24;
    end;
}