/// <summary>
/// pageextension RV Value Entries Ext (ID 50111) extends "Value Entries" page
/// FDD100 2026/05/06: New. (Liuyang)
/// </summary>
pageextension 50116 "RV Value Entries Ext" extends "Value Entries"
{
    layout
    {
        addafter("Invoiced Quantity")
        {
            field("RV_Base Unit of Measure Code"; Rec."RV_Base Unit of Measure Code")
            {
                Description = 'FDD100';
                ApplicationArea = All;
            }
            field("RV_Supp. Unit of Measure Code"; Rec."RV_Supp. Unit of Measure Code")
            {
                Description = 'FDD100';
                ApplicationArea = All;
            }
            field("RV_Item Ledger Entry Qty (KG)"; Rec."RV_IL Entry Qty (Supp. UOM)")
            {
                Description = 'FDD100';
                ApplicationArea = All;
            }
            field("RV_Value Quantity (KG)"; Rec."RV_Value Quantity (Supp. UOM)")
            {
                Description = 'FDD100';
                ApplicationArea = All;
            }
            field("RV_Invoiced Quantity (KG)"; Rec."RV_Invoiced Qty (Supp. UOM)")
            {
                Description = 'FDD100';
                ApplicationArea = All;
            }
        }
    }
}
