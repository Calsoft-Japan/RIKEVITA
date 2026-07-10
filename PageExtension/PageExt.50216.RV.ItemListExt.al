/// <summary>
/// PageExtension RV Item List (ID 50216) extends "Item List"
/// FDD027 2026/07/10: New. (Bobby.ji)
/// </summary>
pageextension 50216 "RV Item List Ext" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field(RV_Grade; Rec.RV_Grade)
            {
                Caption = 'Grade';
                ApplicationArea = all;
            }
        }
    }
}
