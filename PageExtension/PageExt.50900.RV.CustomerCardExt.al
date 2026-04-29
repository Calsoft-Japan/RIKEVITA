/// <summary>
/// PageExtension RV_Customer Card (ID 50900) extends "Customer Card"
/// FDD009 2026/04/29: New. (Shawn)
/// </summary>
pageextension 50900 "RV Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addlast(Invoicing)
        {
            field("RV_Charge Type"; Rec."RV_Charge Type")
            {
                Caption = 'Charge Type';
                ApplicationArea = all;
            }
        }
    }
}
