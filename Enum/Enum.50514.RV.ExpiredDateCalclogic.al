/// <summary>
/// Enum RV Expired Date Calculation Logic (ID 50514).
/// FDD039 2026/08/08: New. (Mike)
/// </summary>
enum 50514 "RV Expired Date Calc. logic"
{
    Extensible = true;
    value(0; "By days") { Caption = 'By days'; }
    value(1; "By month") { Caption = 'By month'; }
    value(2; "By month + end of the month") { Caption = 'By month + end of the month'; }
}