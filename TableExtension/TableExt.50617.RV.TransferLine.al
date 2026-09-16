/// <summary>
/// TableExtension RV Transfer Line (ID 50617) extends Transfer Line table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50617 "RV Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(50600; RV_TransferfromLocation; enum "RV Inventory Status")
        {
            Caption = 'Transit Location';
            fieldClass = FlowField;
            CalcFormula = lookup(Location."RV_Invy. Status" WHERE(Code = field("Transfer-from Code")));
        }
        field(50601; RV_TransferfromBin; enum "RV Inventory Status")
        {
            Caption = 'Transit Bin';
            fieldClass = FlowField;
            CalcFormula = lookup("Bin"."RV_Invy. Status" WHERE("Location Code" = field("Transfer-from Code"), Code = field("Transfer-from Bin Code")));
        }
        field(50602; RV_TransfertoLocation; enum "RV Inventory Status")
        {
            Caption = 'Transfer-to Location';
            fieldClass = FlowField;
            CalcFormula = lookup(Location."RV_Invy. Status" WHERE(Code = field("Transfer-to Code")));
        }
        field(50603; RV_TransfertoBin; enum "RV Inventory Status")
        {
            Caption = 'Transfer-to Bin';
            fieldClass = FlowField;
            CalcFormula = lookup("Bin"."RV_Invy. Status" WHERE("Location Code" = field("Transfer-to Code"), Code = field("Transfer-to Bin Code")));
        }
        field(50604; RV_InTransitLocation; enum "RV Inventory Status")
        {
            Caption = 'In-Transit Location';
            fieldClass = FlowField;
            CalcFormula = lookup(Location."RV_Invy. Status" WHERE(Code = field("In-Transit Code")));
        }
    }
}
