/// <summary>
/// Enum RV MPS Rescheduling Status (ID 50603).
/// FDD011 2026/03/15: New. (stephen)
/// </summary>
enum 50603 "RV MPS Rescheduling Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = 'Need to Update';
    }
    value(1; "OK")
    {
        Caption = 'OK';
    }
    value(2; "Error")
    {
        Caption = 'Error';
    }
}
