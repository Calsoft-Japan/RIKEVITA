/// <summary>
/// TableExtension Item Ledger Entry Ext (ID 50104) extends "Item Ledger Entry" table
/// FDD008 2026/03/14: New. (Liuyang)
/// FDD100 2026/05/06: (Liuyang)
/// </summary>
tableextension 50104 "RV Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50100; "RV_Container No."; Code[20])
        {
            Description = 'FDD008';
            Caption = 'Container No.';
            DataClassification = ToBeClassified;
        }
        field(50101; "RV_Base Unit of Measure Code"; Code[20])
        {
            Description = 'FDD100';
            Caption = 'Base Unit of Measure Code';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Base Unit of Measure" where("No." = field("Item No.")));
        }
        field(50102; "RV_Quantity (Supp. UOM)"; Decimal)
        {
            Description = 'FDD100';
            Caption = 'Quantity (Supp. UOM)';//'Quantity (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }

        field(50103; "RV_Supp. Unit of Measure Code"; Code[20])
        {
            Description = 'FDD100';
            Caption = 'Supp. Unit of Measure Code';////Supplementary Unit of Measure Code
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."RV_Supp. Unit of Measure Code" where("No." = field("Item No.")));
        }
    }
}
