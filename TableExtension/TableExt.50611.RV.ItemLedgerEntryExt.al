/// <summary>
/// TableExtension RV ItemLedgerEntry Ext (ID 50611) extends Item Ledger Entry table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50611 "RV ItemLedgerEntry" extends "Item Ledger Entry"
{
    fields
    {
        field(50600; "RV_TranistLocation"; enum "RV Inventory Status")
        {
            Caption = 'Transit Location';
            fieldClass = FlowField;
            CalcFormula = lookup(Location."RV_Invy. Status" WHERE(Code = field("Location Code")));
        }
    }
}
