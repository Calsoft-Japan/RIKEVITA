/// <summary>
/// TableExtension Item Ledger Entry Ext (ID 50905)
/// FDD028 2026/05/22: New. (Shawn)
/// </summary>
tableextension 50905 "RV ItemLedgerEntry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50900; "RV_Vendor No."; Code[20])
        {
            Description = 'FDD028';
            Caption = 'Vendor No.';
        }
    }
}
