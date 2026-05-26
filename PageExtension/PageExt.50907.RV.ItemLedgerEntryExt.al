/// <summary>
/// PageExtension RV_ItemLedgerEntry (ID 50907) extends "Item Ledger Entries"
/// FDD028 2026/05/22: New. (Shawn) 
/// </summary>
pageextension 50907 "RV_ItemLedgerEntry Ext" extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("RV_Vendor No."; Rec."RV_Vendor No.")
            {
                Caption = 'Vendor No.';
                ApplicationArea = All;
            }
        }
    }
}
