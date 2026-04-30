/// <summary>
/// Enum RV Charge Calculation Status for Charge Allocation (ID 50901)
/// FDD009 2026/04/30: New. (Shawn)
/// </summary>
enum 50991 "RV Charge Calc. Status"
{
    value(0; "Not Started")
    {
        Caption = 'Not Started';
    }
    value(1; "WIP")
    {
        Caption = 'WIP';
    }
    value(2; "Completed")
    {
        Caption = 'Completed';
    }
}
