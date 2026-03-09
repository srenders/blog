query 80206 generalLedger
{
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'generalLedger';
    EntitySetName = 'generalLedger';
    QueryType = API;
    DataAccessIntent = ReadOnly;


    elements
    {
        dataitem(gLEntry; "G/L Entry")
        {
            column(glAccountNo; "G/L Account No.") { }
            column(documentType; "Document Type") { }
            column(documentNumber; "Document No.") { }
            column(sourceType; "Source Type") { }
            column(sourceNo; "Source No.") { }
            column(sourceCode; "Source Code") { }
            column(dimensionSetID; "Dimension Set ID") { }
            column(postingDate; "Posting Date") { }
            column(amount; Amount) { Method = Sum; }
            column(creditAmount; "Credit Amount") { Method = Sum; }
            column(debitAmount; "Debit Amount") { Method = Sum; }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
