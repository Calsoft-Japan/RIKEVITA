/// <summary>
/// Enum RV Planning Status (ID 50602).
/// FDD011 2026/03/15: New. (stephen)
/// </summary>
enum 50602 "RV Planning Status"
{
    Extensible = true;

    value(0; Planning)
    {
        Caption = 'Flexible Planning';
    }

    value(1; Fixed)
    {
        Caption = 'Fixed Planning';
    }
}
