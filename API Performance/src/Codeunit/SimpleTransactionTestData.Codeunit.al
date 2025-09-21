codeunit 91100 "Simple Transaction Test Data"
{
    procedure InsertTestRecords(NumberOfRecords: Integer)
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
        i: Integer;
        EntryNo: Integer;
        CustomerList: List of [Code[20]];
        DialogWindow: Dialog;
    begin
        // Pre-load customer list once for performance
        LoadCustomerList(CustomerList);

        // Get starting Entry No once
        EntryNo := SimpleTransactionEntry.GetNextEntryNo();

        // Show progress dialog for large operations
        if NumberOfRecords > 1000 then begin
            DialogWindow.Open('Inserting test records: #1########## / #2##########');
            DialogWindow.Update(1, 0);
            DialogWindow.Update(2, NumberOfRecords);
        end;

        for i := 1 to NumberOfRecords do begin
            Clear(SimpleTransactionEntry);
            SimpleTransactionEntry."Entry No." := EntryNo;
            SimpleTransactionEntry."Customer No." := GetTestCustomerNoFromList(i, CustomerList);
            SimpleTransactionEntry."Posting Date" := GetRandomPostingDate(i);
            SimpleTransactionEntry."Document Type" := GetTestDocumentType(i);
            SimpleTransactionEntry."Document No." := 'TEST-' + GetFormattedNumber(i);
            SimpleTransactionEntry."Description" := 'Test transaction entry ' + Format(i);
            SimpleTransactionEntry."Amount (LCY)" := GetRandomAmountByDocType(SimpleTransactionEntry."Document Type");
            SimpleTransactionEntry.Insert(false);

            // Increment Entry No by 10 for next record
            EntryNo += 10;

            // Update progress every 1000 records
            if (NumberOfRecords > 1000) and (i mod 1000 = 0) then
                DialogWindow.Update(1, i);
        end;

        if NumberOfRecords > 1000 then
            DialogWindow.Close();
    end;

    procedure TruncateTestRecords()
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
    begin
        // Delete only test records (those with Document No. starting with 'TEST-')
        SimpleTransactionEntry.SetFilter("Document No.", 'TEST-*');
        if not SimpleTransactionEntry.IsEmpty() then
            SimpleTransactionEntry.DeleteAll();
    end;

    procedure DeleteAllRecords()
    var
        SimpleTransactionEntry: Record "Simple Transaction Entry";
    begin
        SimpleTransactionEntry.DeleteAll();
    end;

    local procedure LoadCustomerList(var CustomerList: List of [Code[20]])
    var
        Customer: Record Customer;
    begin
        CustomerList.RemoveRange(1, CustomerList.Count());
        if Customer.FindSet() then
            repeat
                CustomerList.Add(Customer."No.");
            until (Customer.Next() = 0) or (CustomerList.Count() >= 100); // Limit to 100 customers for variety

        // If no customers exist, add a default empty value
        if CustomerList.Count() = 0 then
            CustomerList.Add('');
    end;

    local procedure GetTestCustomerNoFromList(EntryNo: Integer; CustomerList: List of [Code[20]]): Code[20]
    begin
        if CustomerList.Count() = 0 then
            exit('');

        // Return a customer from the list, cycling through them
        exit(CustomerList.Get((EntryNo mod CustomerList.Count()) + 1));
    end;

    local procedure GetRandomAmountByDocType(DocumentType: Enum "Simple Document Type"): Decimal
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

    local procedure GetRandomPostingDate(RecordNumber: Integer): Date
    var
        DaysBack: Integer;
    begin
        // Limit the range to past 365 days and cycle through it
        DaysBack := (RecordNumber mod 365) + 1;
        exit(CalcDate('<-' + Format(DaysBack) + 'D>', Today()));
    end;

    local procedure GetFormattedNumber(Number: Integer): Text
    begin
        if Number < 10 then
            exit('000' + Format(Number));

        if Number < 100 then
            exit('00' + Format(Number));

        if Number < 1000 then
            exit('0' + Format(Number));

        exit(Format(Number));
    end;

    local procedure GetTestDocumentType(EntryNo: Integer): Enum "Simple Document Type"
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
}