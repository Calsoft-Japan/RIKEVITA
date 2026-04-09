/// <summary>
/// Enum RV Prod. Results Data Type (ID 50600).
/// FDD010 2026/02/23: New. (stephen)
/// </summary>
enum 50600 "RV Prod. Results Data Type"
{
    Extensible = true;
    Caption = 'RV Prod. Results Data Type';
    value(0; " ") { Caption = ' '; }
    value(1; "Planned Output") { Caption = 'Planned Output'; }
    value(2; "Planned Consumption") { Caption = 'Planned Consumption'; }
    value(3; "Adjust Output") { Caption = 'Adjust Output'; }
    value(4; "Adjust Consumption") { Caption = 'Adjust Consumption'; }
    value(5; "Recycle Consumption") { Caption = 'Recycle Consumption'; }
}