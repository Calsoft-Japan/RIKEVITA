/// <summary>
/// Enum RIKE Value Table Type (ID 50501).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50501 "RIKE Value Table Type"
{
    Extensible = true;
    value(0; "List") { Caption = 'List'; }
    value(1; "Single") { Caption = 'Single'; }
    value(2; "Range") { Caption = 'Range'; }
    value(3; "Table") { Caption = 'Table'; }
}