/// <summary>
/// PageExtension RV_ItemJnl (ID 50908) extends "Item Journal"
/// FDD028 2026/05/22: New. (Shawn) 
/// On-demand request: add RV_Item Journal Comment by Bobby 09/11/2026
/// </summary>
pageextension 50908 "RV_ItemJnl Ext" extends "Item Journal"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Item Journal Comment"; Rec."RV_Item Journal Comment")//On-demand request
            {
                Editable = true;
                ApplicationArea = All;
            }
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
