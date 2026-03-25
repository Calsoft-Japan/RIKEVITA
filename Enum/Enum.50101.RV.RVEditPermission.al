/// <summary>
/// Enum RIKE RV_EditPermission (ID 50101)
/// FDD008 2026/03/15: New. (Liuyang)
/// </summary>
enum 50101 "RV EditPermission"
{
    Extensible = true;

    value(0; Allowed)
    {
        Caption = 'Allowed';
    }
    value(1; Prohibited)
    {
        Caption = 'Prohibited';
    }
}
