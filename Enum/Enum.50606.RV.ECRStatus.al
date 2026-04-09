/// <summary>
/// Enum RV ECR Status (ID 50606).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
enum 50606 "RV ECR Status"
{
    Extensible = true;

    // add blank value to avoid default value issue
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "On-Hold")
    {
        Caption = 'On-Hold';
    }
    value(2; Released)
    {
        Caption = 'Released';
    }
}
