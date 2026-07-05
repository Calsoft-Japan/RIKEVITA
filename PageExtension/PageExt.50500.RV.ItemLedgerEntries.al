/// <summary>
/// PageExtension RV Item Ledger Entry (ID 50500) extends "Item Ledger Entries"
/// FDD039 2026/06/21: New. (Mike)
/// </summary>
pageextension 50500 "RV Item Ledger Entry" extends "Item Ledger Entries"
{
    layout
    {
        modify("Lot No.")
        {
            Visible = true;
        }
        moveafter("Item No."; "Lot No.")
    }
}
