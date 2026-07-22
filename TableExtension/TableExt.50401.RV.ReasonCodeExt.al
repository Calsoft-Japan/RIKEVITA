/// <summary>
/// TableExtension Reason Code Type" extends "Reason Code
/// 2026/07/21: For Backdated stock Balance. (Stephen)
/// </summary>

tableextension 50401 "RV Reason Code Type" extends "Reason Code"
{
    fields
    {
        field(50400; "RV_Reason Code Type"; enum "RV Reason Code Type")
        {
            Caption = 'Reason Code Type';
            DataClassification = ToBeClassified;
        }
    }
}
