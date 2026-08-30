/// <summary>
/// TableExtension Sales Shipment Line Ext (ID 50902)
/// FDD009 2026/04/29: New. (Shawn)
/// </summary>
tableextension 50902 "RV SalesShptLine Ext" extends "Sales Shipment Line"
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
            Caption = 'Charge Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."RV_Charge Type" where("No." = field("Sell-to Customer No.")));
        }
        field(50911; "RV_Warehouse Shipment No."; Code[20])
        {
            Description = 'FDD009';
            Caption = 'Warehouse Shipment No.';
        }
        field(50912; "RV_Posted Whse. Shipment No."; Code[20])
        {
            Description = 'FDD009';
            Caption = 'Posted Warehouse Shipment No.';
        }
    }
}
