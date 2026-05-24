/// <summary>
/// PageExtension RV_ItemJnl (ID 50908) extends "Item Journal"
/// FDD028 2026/05/22: New. (Shawn) 
/// </summary>
pageextension 50908 "RV_ItemJnl Ext" extends "Item Journal"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Source Type"; Rec."Source Type")
            {
                Editable = true;
                Visible = false;
                ApplicationArea = All;
            }
            field("Source No."; Rec."Source No.")
            {
                Editable = true;
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
}
