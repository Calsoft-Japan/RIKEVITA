/// <summary>
/// TableExtension RV Posted Whse Shipment Line (ID 50208) extends Posted Whse. Shipment Line table
/// FDD019 2026/04/21: New. (Bobby.ji)
/// </summary>
tableextension 50208 "RV Posted Whse Shipment Line" extends "Posted Whse. Shipment Line"
{
    fields
    {
        field(50200; "RV_Symbol Display Packing List"; Boolean)
        {
            Caption = 'Print RSPO No.';
            Description = 'FDD019';
            FieldClass = FlowField;
            CalcFormula = Lookup("RV Item Symbol Setting"."Symbol Display Packing List" WHERE("Item Code" = FIELD("Item No.")));
        }
    }
}
