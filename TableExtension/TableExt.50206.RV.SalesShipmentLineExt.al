/// <summary>
/// TableExtension RV_Sales Shipment Line (ID 50206) extends Sales Shipment Line table
/// FDD020 2026/04/08: New. (Bobby.ji)
/// </summary>
tableextension 50206 "RV Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(50200; "RV_Print RSPO No."; Boolean)
        {
            Caption = 'Print RSPO No.';
            Description = 'FDD020';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."RV_Print RSPO No." WHERE("No." = FIELD("No.")));
        }

    }
}
