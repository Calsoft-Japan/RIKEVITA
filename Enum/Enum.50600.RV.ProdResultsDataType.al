/// <summary>
/// Enum RV Prod. Results Data Type (ID 50600).
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
enum 50600 "RV Prod. Results Data Type"
{
    Extensible = true;
    Caption = 'RV Prod. Results Data Type';
    value(0; "Planned Output") { Caption = 'Planned Output'; }
    value(1; "Planned Consumption") { Caption = 'Planned Consumption'; }
    value(2; "Adjust Output") { Caption = 'Adjust Output'; }
    value(3; "Adjust Consumption") { Caption = 'Adjust Consumption'; }
}