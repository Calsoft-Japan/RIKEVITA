/// <summary>
/// TableExtension Sales Line Ext (ID 50901)
/// FDD009 2026/04/29: New. (Shawn)
/// </summary>
tableextension 50901 "RV SalesLine Ext" extends "Sales Line"
{
    fields
    {
        field(50900; "RV_Freight Charge"; Decimal)
        {
            Description = 'FDD009';
            Caption = 'Freight Charge';
        }
        field(50901; "RV_Other Charge"; Decimal)
        {
            Description = 'FDD009';
            Caption = 'Other Charge';
        }
        field(50902; "RV_Charge Type"; Enum "RV Charge Type")
        {
            Description = 'FDD009';
            Editable = false;
            Caption = 'Charge Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."RV_Charge Type" where("No." = field("Sell-to Customer No.")));
        }
        field(50903; "RV_Item Type"; Enum "Item Type")
        {
            Description = 'FDD009';
            Editable = false;
            Caption = 'Item Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Type where("No." = field("No.")));
        }
        field(50904; "RV_Charge Allocated"; Boolean)
        {
            Description = 'FDD009';
            Editable = false;
            Caption = 'Charge Allocated';
            FieldClass = FlowField;
            CalcFormula = exist("RV Charge Calc. Line" where("Sales Order No." = field("Document No."),
                                                            "Sales Order Line No." = field("Line No.")));
        }
    }
}
