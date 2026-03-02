/// <summary>
/// Enum RIKE QC Standard Type (ID 50504).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50504 "RIKE QC Standard Type"
{
    Extensible = true;
    //Internal,External
    value(0; "Internal") { Caption = 'Internal'; }
    value(1; "External") { Caption = 'External'; }
}