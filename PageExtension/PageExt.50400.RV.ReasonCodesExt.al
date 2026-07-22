
/// <summary>
/// TableExtension Reason Code Type" extends "Reason Code
/// 2026/07/21: For Backdated stock Balance. (Stephen)
/// </summary>

pageextension 50400 "RV Reason Codes" extends "Reason Codes"
{
    layout
    {
        addafter(Description)
        {
            field(RV_ETA; Rec."RV_Reason Code Type")
            {
                ApplicationArea = All;
                Description = 'Reason Code Type';
            }
        }
    }
}
