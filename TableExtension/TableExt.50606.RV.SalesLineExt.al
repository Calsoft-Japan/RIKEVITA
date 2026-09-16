/// <summary>
/// TableExtension RV Sales Line (ID 50606) extends Sales Line table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50606 "RV Sales Line" extends "Sales Line"
{
    fields
    {
        field(50600; "RV_ECR Required"; Boolean)
        {
            Caption = 'ECR Required';
            DataClassification = ToBeClassified;
        }

        field(50601; "RV_ECR Date"; Date)
        {
            Caption = 'ECR Date';
            DataClassification = ToBeClassified;
        }

        field(50602; "RV_Stuffing Date"; Date)
        {
            Caption = 'Stuffing Date';
            DataClassification = ToBeClassified;
        }
        field(50603; "RV_isNotNew"; Boolean)
        {
            Caption = 'Is New';
            DataClassification = ToBeClassified;
        }
        field(50604; "RV_RDD"; Date)
        {
            Caption = 'RDD';
            DataClassification = ToBeClassified;
            description = 'FDD006';
        }
        field(50605; RV_TranistLocation; enum "RV Inventory Status")
        {
            Caption = 'Transit Location';
            fieldClass = FlowField;
            CalcFormula = lookup(Location."RV_Invy. Status" WHERE(Code = field("Location Code")));
        }
        field(50606; RV_TranistBin; enum "RV Inventory Status")
        {
            Caption = 'Transit Bin';
            fieldClass = FlowField;
            CalcFormula = lookup("Bin"."RV_Invy. Status" WHERE("Location Code" = field("Location Code"), Code = field("Bin Code")));
        }
    }
}
