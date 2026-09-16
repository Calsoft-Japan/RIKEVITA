/// <summary>
/// TableExtension RV Planning Component Ext (ID 50615) extends Planning Component table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50616 "RV Requisition Line Ext" extends "Requisition Line"
{
    fields
    {
        field(50600; RV_TranistLocation; enum "RV Inventory Status")
        {
            Caption = 'Transit Location';
            fieldClass = FlowField;
            CalcFormula = lookup(Location."RV_Invy. Status" WHERE(Code = field("Location Code")));
        }
        field(50601; RV_TranistBin; enum "RV Inventory Status")
        {
            Caption = 'Transit Bin';
            fieldClass = FlowField;
            CalcFormula = lookup("Bin"."RV_Invy. Status" WHERE("Location Code" = field("Location Code"), Code = field("Bin Code")));
        }
        field(50602; RV_TranistFromLocation; enum "RV Inventory Status")
        {
            Caption = 'Transfer-from Location';
            fieldClass = FlowField;
            CalcFormula = lookup(Location."RV_Invy. Status" WHERE(Code = field("Transfer-from Code")));
        }
        field(50603; RV_TranistFromBin; enum "RV Inventory Status")
        {
            Caption = 'Transit-from Bin';
            fieldClass = FlowField;
            CalcFormula = lookup("Bin"."RV_Invy. Status" WHERE("Location Code" = field("Transfer-from Code"), Code = field("Bin Code")));
        }
    }

}
