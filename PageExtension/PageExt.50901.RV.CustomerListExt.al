/// <summary>
/// PageExtension RV_Customer Card (ID 50901) extends "Customer List"
/// FDD009 2026/04/29: New. (Shawn)
/// </summary>
pageextension 50901 "RV Customer List Ext" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("RV_Charge Type"; Rec."RV_Charge Type")
            {
                Caption = 'Charge Type';
                ApplicationArea = all;
            }
        }
    }
}
