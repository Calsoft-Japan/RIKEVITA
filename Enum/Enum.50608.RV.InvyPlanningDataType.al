/// <summary>
/// Enum RV Invy. Planning Data Type (ID 50608).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
enum 50608 "RV Invy. Planning Data Type"
{
    Extensible = true;

    value(0; "Gross Requirement")
    {
        Caption = 'Gross Requirement';
    }
    value(1; "Scheduled Receipt")
    {
        Caption = 'Scheduled Receipt';
    }
    value(3; "Receipt from Transit")
    {
        Caption = 'Receipt from Transit';
    }
    value(4; "Expired Inventory")
    {
        Caption = 'Expired Inventory';
    }
    value(5; "Planned Inventory")
    {
        Caption = 'Planned Inventory';
    }
}
