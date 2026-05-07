/// <summary>
/// Enum RV Type (ID 50500).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50500 "RV Type"
{
    Extensible = true;
    value(0; " ") { Caption = ' '; }
    value(1; "Alphanumeric") { Caption = 'Alphanumeric'; }
    value(2; "Numeric") { Caption = 'Numeric'; }
    value(3; "Blooean") { Caption = 'Blooean'; }
}