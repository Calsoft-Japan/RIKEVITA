/// <summary>
/// TableExtension RV Ship-to Address (ID 50605) extends Ship-to Address table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50605 "RV Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50600; "RV_Shipment Type"; Enum "RV Shipment Type")
        {
            Caption = 'Shipment Type';
            DataClassification = ToBeClassified;
        }
        field(50601; "RV_Bypass ECR"; Boolean)
        {
            Caption = 'Bypass ECR';
            DataClassification = ToBeClassified;
        }
        field(50602; "RV_Holding Category"; Code[20])
        {
            Caption = 'Holding Category';
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region"."RV_Sailing Category Code" where(Code = field("Country/Region Code")));
            Editable = false;
        }
        field(50603; "RV_Holding Period"; DateFormula)
        {
            Caption = 'Holding Period';
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region"."RV_Sailing Period" where(Code = field("Country/Region Code")));
            Editable = false;
        }
    }
}
