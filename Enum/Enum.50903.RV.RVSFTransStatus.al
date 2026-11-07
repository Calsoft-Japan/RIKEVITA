/// <summary>
/// Enum RV Salesforce Trans Status (ID 50903)
/// FDD004 2026/11/07: New. (Shawn)
/// </summary>
enum 50903 "RV Salesforce Trans Status"
{
    value(0; "Interfaced")
    {
        Caption = 'Interfaced';
    }
    value(1; "Processed")
    {
        Caption = 'Processed';
    }
    value(2; "Process Error")
    {
        Caption = 'Process Error';
    }
}
