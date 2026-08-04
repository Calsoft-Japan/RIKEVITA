/// <summary>
/// TableExtension Posted Whsh. Header Ext (ID 50906)
/// FDD009 2026/08/04: New. (Shawn)
/// </summary>
tableextension 50906 "RV Posted Whsh. Header" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(50900; "RV_Charge Allocated"; Boolean)
        {
            Description = 'FDD009';
            Editable = false;
            Caption = 'Charge Allocated';
            FieldClass = FlowField;
            CalcFormula = exist("RV Charge Calc. Line" where("Posted Whse. Shipment No." = field("No.")));
        }
    }
}