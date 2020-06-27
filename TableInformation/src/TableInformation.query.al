query 60125 qyrTableInformation
{
    QueryType = Normal;
    DataAccessIntent = ReadOnly;
    
    elements
    {
        dataitem(TableInformation;"Table Information")
        {
            column(CompanyName; "Company Name")
            {
            }
            column(NoofRecords; "No. of Records")
            {
            }
            column(RecordSize; "Record Size")
            {
            }
            column(SizeKB; "Size (KB)")
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(TableName; "Table Name")
            {
            }
            column(TableNo; "Table No.")
            {
            }
        }
    }
}