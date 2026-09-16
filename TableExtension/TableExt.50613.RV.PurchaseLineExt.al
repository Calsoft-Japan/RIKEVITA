/// <summary>
/// TableExtension RV Purchase Line Ext (ID 50613) extends Purchase Line table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50613 "RV Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(50600; RV_TranistLocation; enum "RV Inventory Status")
        {
            Caption = 'Transit Location';
            fieldClass = FlowField;
            CalcFormula = lookup(Location."RV_Invy. Status" WHERE(Code = FIELD("Location Code")));
        }
        field(50601; RV_TranistBin; enum "RV Inventory Status")
        {
            Caption = 'Transit Bin';
            fieldClass = FlowField;
            CalcFormula = lookup("Bin"."RV_Invy. Status" WHERE("Location Code" = field("Location Code"), Code = field("Bin Code")));
        }
    }
}
