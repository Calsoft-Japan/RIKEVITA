tableextension 50608 "RV_Lot No. Information" extends "Lot No. Information"
{
    fields
    {
        field(50600; "RV_Manufacture Date"; Date)
        {
            Caption = 'Manufacture Date';
            Description = 'FDD006';
            Editable = false;

            FieldClass = FlowField;
            CalcFormula = min("Item Ledger Entry"."Posting Date"
            where(
                "Lot No." = FIELD("Lot No."),
                "Item No." = FIELD("Item No."),
                "Variant Code" = FIELD("Variant Code"),
                "Order Type" = const("Production"),
                "Entry Type" = const(Output)));
        }
    }
}
