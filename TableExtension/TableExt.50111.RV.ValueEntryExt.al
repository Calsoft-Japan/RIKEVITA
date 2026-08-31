/// <summary>
/// TableExtension RV Value Entry Ext (ID 50111) extends "Value Entry" table
/// FDD100 2026/05/06: New. (Liuyang)
/// </summary>
tableextension 50111 "RV Value Entry Ext" extends "Value Entry"
{
    fields
    {
        field(50100; "RV_Base Unit of Measure Code"; Code[20])
        {
            Description = 'FDD100';
            Caption = 'Base Unit of Measure Code';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Base Unit of Measure" where("No." = field("Item No.")));
        }
        field(50101; "RV_IL Entry Qty (Supp. UOM)"; Decimal)
        {
            Description = 'FDD100';
            Caption = 'RV_ILE Qty. (Supp. UOM)';//'Item Ledger Entry Quantity (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50102; "RV_Value Quantity (Supp. UOM)"; Decimal)
        {
            Description = 'FDD100';
            Caption = 'RV_Value Quantity (Supp. UOM)';//'Value Quantity (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50103; "RV_Invoiced Qty (Supp. UOM)"; Decimal)
        {
            Description = 'FDD100';
            Caption = 'RV_Invoiced Qty. (Supp. UOM)';//'Invoiced Quantity (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50104; "RV_Supp. Unit of Measure Code"; Code[20])
        {
            Description = 'FDD100';
            Caption = 'Supp. Unit of Measure Code';//Supplementary Unit of Measure Code
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."RV_Supp. Unit of Measure Code" where("No." = field("Item No.")));
        }
    }
}
