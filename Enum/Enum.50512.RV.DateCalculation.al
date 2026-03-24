/// <summary>
/// Enum RV Date Calculation (ID 50512).
/// FDD039 2026/02/23: New. (Mike)
/// </summary>
enum 50512 "RV Date Calculation"
{
    Extensible = true;
    value(0; "Shelf Life By Months Without Days MMM-YYYY") { Caption = 'Shelf Life By Months Without Days MMM-YYYY'; }
    value(1; "Shelf Life By Months DD-MMM-YYYY") { Caption = 'Shelf Life By Months DD-MMM-YYYY'; }
}