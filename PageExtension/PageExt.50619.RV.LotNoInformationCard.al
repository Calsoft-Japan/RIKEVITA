
/// <summary>
/// PageExtension RV_Lot No. Information Card (ID 50619) extends "Lot No. Information Card"
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
pageextension 50619 "RV_Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addlast(General)
        {
            field("RV_Manufacture Date"; rec."RV_Manufacture Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
