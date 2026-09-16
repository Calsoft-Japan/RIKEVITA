/// <summary>
/// TableExtension RV Reservation Entry Ext (ID 50612) extends Reservation Entry table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50612 "RV_Reservation Entry" extends "Reservation Entry"
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
