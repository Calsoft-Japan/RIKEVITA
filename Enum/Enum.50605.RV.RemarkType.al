/// <summary>
/// Enum RV Remark Type (ID 50605).
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
enum 50605 "RV Remark Type"
{
    Extensible = true;

    //add blank value to avoid default value issue
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Common)
    {
        Caption = 'Common';
    }
    value(2; ECR)
    {
        Caption = 'ECR';
    }
}