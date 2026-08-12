/// <summary>
/// TableExtension Reason Code Type" extends "Reason Code
/// 2026/07/21: For Backdated stock Balance. (Stephen)
/// </summary>
enum 50401 "RV Reason Code Type"
{
    Extensible = true;
    value(0; Blank)
    {
        Caption = ' ';
    }
    value(1; Variance)
    {
        Caption = 'Variance';
    }
    value(2; "Waste Scrap")
    {
        Caption = 'Waste or Scrap';
    }
    value(3; "Sample Dispose")
    {
        Caption = 'Sample or Dispose';
    }
    value(4; "Transfer Site")
    {
        Caption = 'Transfer Site';
    }
}
