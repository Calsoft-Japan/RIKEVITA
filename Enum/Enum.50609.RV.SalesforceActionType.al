/// <summary>
/// Enum RV Salesforce Action Type (ID 50609).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
enum 50609 "RV Salesforce Action Type"
{
    Extensible = true;
    value(0; New)
    {
        Caption = 'New';
    }
    value(1; Revise)
    {
        Caption = 'Revise';
    }
    value(2; Cancel)
    {
        Caption = 'Cancel';
    }
}
