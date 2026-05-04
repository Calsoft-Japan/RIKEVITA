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
        field(50101; "RV_Item Ledger Entry Qty (KG)"; Decimal)
        {
            Description = 'FDD100';
            Caption = 'Item Ledger Entry Quantity (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50102; "RV_Value Quantity (KG)"; Decimal)
        {
            Description = 'FDD100';
            Caption = 'Value Quantity (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50103; "RV_Invoiced Quantity (KG)"; Decimal)
        {
            Description = 'FDD100';
            Caption = 'Invoiced Quantity (KG)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
    }
}
