/// <summary>
/// Enum RV Shipment Type (ID 50604).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
enum 50604 "RV Shipment Type"
{
    Extensible = true;
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Sea)
    {
        Caption = 'Sea';
    }
    value(2; Land)
    {
        Caption = 'Land';
    }
    value(3; Air)
    {
        Caption = 'Air';
    }
}