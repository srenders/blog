codeunit 91101 "Base Test Data Generator"
{
    // This is an abstract base class with shared helper methods
    // It cannot be instantiated directly but provides common functionality

    var
        CustomerListCache: List of [Code[20]];
        CustomerListLoaded: Boolean;

    /// <summary>
    /// Loads customer list into cache for reuse across multiple inserts
    /// </summary>
    procedure LoadCustomerList(var CustomerList: List of [Code[20]])
    var
        Customer: Record Customer;
    begin
        // Use cached list if already loaded
        if CustomerListLoaded then begin
            CustomerList := CustomerListCache;
            exit;
        end;

        CustomerList.RemoveRange(1, CustomerList.Count());
        if Customer.FindSet() then
            repeat
                CustomerList.Add(Customer."No.");
            until (Customer.Next() = 0) or (CustomerList.Count() >= 100); // Limit to 100 customers for variety

        // If no customers exist, add a default empty value
        if CustomerList.Count() = 0 then
            CustomerList.Add('');

        // Cache the list
        CustomerListCache := CustomerList;
        CustomerListLoaded := true;
    end;

    /// <summary>
    /// Gets a customer number from the list by cycling through the list
    /// </summary>
    procedure GetTestCustomerNoFromList(EntryNo: Integer; CustomerList: List of [Code[20]]): Code[20]
    begin
        if CustomerList.Count() = 0 then
            exit('');

        // Return a customer from the list, cycling through them
        exit(CustomerList.Get((EntryNo mod CustomerList.Count()) + 1));
    end;

    /// <summary>
    /// Generates a random amount based on document type
    /// </summary>
    procedure GetRandomAmountByDocType(DocumentType: Enum "Simple Document Type"): Decimal
    var
        BaseAmounts: array[10] of Decimal;
        RandomIndex: Integer;
        VariationFactor: Decimal;
        BaseAmount: Decimal;
    begin
        // Create an array of realistic base amounts
        BaseAmounts[1] := 50.00;
        BaseAmounts[2] := 100.00;
        BaseAmounts[3] := 150.00;
        BaseAmounts[4] := 200.00;
        BaseAmounts[5] := 250.00;
        BaseAmounts[6] := 500.00;
        BaseAmounts[7] := 750.00;
        BaseAmounts[8] := 1000.00;
        BaseAmounts[9] := 1500.00;
        BaseAmounts[10] := 2000.00;

        // Pick a random base amount (1-10)
        RandomIndex := (Random(10000) mod 10) + 1;

        // Add some variation (75% to 125% of base amount)
        VariationFactor := 0.75 + (Random(10000) mod 500) / 1000;

        BaseAmount := BaseAmounts[RandomIndex] * VariationFactor;

        // Apply sign based on document type
        case DocumentType of
            "Simple Document Type"::Invoice:
                exit(BaseAmount); // Positive amount
            "Simple Document Type"::"Credit Memo":
                exit(-BaseAmount); // Negative amount
            "Simple Document Type"::Payment:
                exit(-BaseAmount); // Negative amount (payment reduces balance)
            "Simple Document Type"::Refund:
                exit(BaseAmount); // Positive amount (refund increases balance)
            else
                exit(BaseAmount); // Default to positive
        end;
    end;

    /// <summary>
    /// Generates a random posting date within the past 365 days
    /// </summary>
    procedure GetRandomPostingDate(RecordNumber: Integer): Date
    var
        DaysBack: Integer;
    begin
        // Limit the range to past 365 days and cycle through it
        DaysBack := (RecordNumber mod 365) + 1;
        exit(CalcDate('<-' + Format(DaysBack) + 'D>', Today()));
    end;

    /// <summary>
    /// Formats a number with leading zeros
    /// </summary>
    procedure GetFormattedNumber(Number: Integer): Text
    begin
        if Number < 10 then
            exit('000' + Format(Number));

        if Number < 100 then
            exit('00' + Format(Number));

        if Number < 1000 then
            exit('0' + Format(Number));

        exit(Format(Number));
    end;

    /// <summary>
    /// Gets a document type by cycling through the available types
    /// </summary>
    procedure GetTestDocumentType(EntryNo: Integer): Enum "Simple Document Type"
    begin
        case EntryNo mod 4 of
            0:
                exit("Simple Document Type"::Invoice);
            1:
                exit("Simple Document Type"::"Credit Memo");
            2:
                exit("Simple Document Type"::Payment);
            3:
                exit("Simple Document Type"::Refund);
        end;
    end;

    /// <summary>
    /// Opens a progress dialog for long-running operations
    /// </summary>
    procedure OpenProgressDialog(var DialogWindow: Dialog; TableName: Text[100]; NumberOfRecords: Integer)
    begin
        if NumberOfRecords > 1000 then begin
            DialogWindow.Open('Inserting test records (' + TableName + '):\Progress: #1########## / #2##########');
            DialogWindow.Update(1, 0);
            DialogWindow.Update(2, NumberOfRecords);
        end;
    end;

    /// <summary>
    /// Updates progress dialog
    /// </summary>
    procedure UpdateProgressDialog(var DialogWindow: Dialog; CurrentRecord: Integer; NumberOfRecords: Integer)
    begin
        if (NumberOfRecords > 1000) and (CurrentRecord mod 1000 = 0) then
            DialogWindow.Update(1, CurrentRecord);
    end;

    /// <summary>
    /// Closes progress dialog if it was opened
    /// </summary>
    procedure CloseProgressDialog(var DialogWindow: Dialog; NumberOfRecords: Integer)
    begin
        if NumberOfRecords > 1000 then
            DialogWindow.Close();
    end;

    /// <summary>
    /// Clears the customer list cache (useful for testing or when customer data changes)
    /// </summary>
    procedure ClearCustomerCache()
    begin
        CustomerListCache.RemoveRange(1, CustomerListCache.Count());
        CustomerListLoaded := false;
    end;
}
