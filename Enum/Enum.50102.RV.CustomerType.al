/// <summary>
/// Enum RV Customer Type (ID 50102) 
/// FDD024 2026/04/28: New. (Liuyang)
/// </summary>
enum 50102 "RV Customer Type"
{
    Extensible = true;

    value(0; "Overseas Customer")
    {
        Caption = 'Overseas Customer';
    }
    value(1; "Local Customer")
    {
        Caption = 'Local Customer';
    }
}
