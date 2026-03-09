query 80205 ValueEntries
{
    Caption = 'ValueEntries';
    QueryType = API;
    APIPublisher = 'solutize';
    APIGroup = 'powerBI';
    APIVersion = 'v1.1';
    EntityName = 'valueentriesqry';
    EntitySetName = 'valueentriesqry';
    DataAccessIntent = ReadOnly;
    UsageCategory = ReportsAndAnalysis;
    

    elements
    {
        dataitem(ValueEntry; "Value Entry")
        {
            column(itemNo; "Item No.") { }
            column(itemLedgerEntryType; "Item Ledger Entry Type") { }
            column(documentNo; "Document No.") { }
            column(sourceNo; "Source No.") { }
            column(locationCode; "Location Code") { }
            column(postingDate; "Posting Date") { }
            column(salesAmountActual; "Sales Amount (Actual)") { Method = Sum; }
            column(valuedQuantity; "Valued Quantity") { Method = Sum; }
        }
    }
}
