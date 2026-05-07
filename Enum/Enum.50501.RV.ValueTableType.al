/// <summary>
/// Enum RV Value Table Type (ID 50501).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50501 "RV Value Table Type"
{
    Extensible = true;
    value(0; " ") { Caption = ' '; }
    value(1; "List") { Caption = 'List'; }
    value(2; "Single") { Caption = 'Single'; }
    value(3; "Range") { Caption = 'Range'; }
    value(4; "Table") { Caption = 'Table'; }
}