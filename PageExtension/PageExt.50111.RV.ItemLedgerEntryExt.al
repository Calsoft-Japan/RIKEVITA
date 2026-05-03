/// <summary>
/// pageextension RV Item Ledger Entry Ext (ID 50111) extends "Item Ledger Entries" page
/// FDD008 2026/03/14: New. (Liuyang)
/// FDD100 2026/05/06:  (Liuyang)
/// </summary>
pageextension 50111 "RV Item Ledger Entry Ext" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Lot No.")
        {
            field("RV_Container No."; Rec."RV_Container No.")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
        }

        addafter("Reserved Quantity")
        {
            field("RV_Base Unit of Measure Code"; Rec."RV_Base Unit of Measure Code")
            {
                Description = 'FDD100';
                ApplicationArea = All;
            }
            field("RV_Quantity (KG)"; Rec."RV_Quantity (KG)")
            {
                Description = 'FDD100';
                ApplicationArea = All;
            }
        }
    }
}
