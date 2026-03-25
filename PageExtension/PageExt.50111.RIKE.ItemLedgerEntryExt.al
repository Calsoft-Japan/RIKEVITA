/// <summary>
/// pageextension Warehouse Shipment Ext (ID 50106) extends "Warehouse Shipment" page
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
pageextension 50111 "RV Item Ledger Entry Ext" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Lot No.")
        {
            field("RV_Container No."; Rec."RV Container No.")
            {
                ApplicationArea = All;
                Description = 'FDD008';
            }
        }
    }
}
