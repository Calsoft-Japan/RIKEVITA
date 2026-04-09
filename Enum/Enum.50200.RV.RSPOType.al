/// <summary>
/// Enum RIKE RV_RSPO Type (ID 50200)
/// FDD020 2026/04/08: New. (Bobby.ji)
/// </summary>
enum 50200 "RV RSPO Type"
{
    Extensible = true;
    value(0; "Non-RSPO")
    {
        Caption = 'Non-RSPO';
    }
    value(1; "Mass Balance")
    {
        Caption = 'Mass Balance';
    }
    value(2; Segregation)
    {
        Caption = 'Segregation';
    }
}
