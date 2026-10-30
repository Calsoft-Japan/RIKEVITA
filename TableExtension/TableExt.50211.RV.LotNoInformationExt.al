/// <summary>
/// TableExtension RV Lot No. Information (ID 50211) extends Lot No. Information table
/// additional requirement 2026/10/30: New. (Bobby.ji)
/// </summary>
tableextension 50211 "RV Lot No. Information Ext" extends "Lot No. Information"
{
    fields
    {

        field(50200; "RV_Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Description = 'additional requirement';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Description" WHERE("No." = field("Item No.")));
        }
        field(50201; "RV_Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            Description = 'additional requirement';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Base Unit of Measure" WHERE("No." = field("Item No.")));
        }
        field(50202; "RV_Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            Description = 'additional requirement';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Item Category Code" WHERE("No." = field("Item No.")));
        }
    }
}
