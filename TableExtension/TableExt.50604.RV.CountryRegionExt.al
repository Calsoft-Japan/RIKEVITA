/// <summary>
/// TableExtension RV Country/Region (ID 50604) extends Country/Region table
/// FDD006 2026/03/31: New. (Stephen)
/// </summary>
tableextension 50604 "RV_Country/Region Ext" extends "Country/Region"
{
    fields
    {
        field(50600; "RV_Sailing Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sailing Category Code';
            TableRelation = "RV Sailing Category";

            trigger OnValidate()
            var
                SailingCategory: Record "RV Sailing Category";
            begin
                if SailingCategory.Get("RV_Sailing Category Code") then
                    "RV_Sailing Period" := SailingCategory."Sailing Period Calculation"
                else
                    Evaluate("RV_Sailing Period", '');
            end;
        }
        field(50601; "RV_Sailing Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sailing Period';
        }
    }
}
