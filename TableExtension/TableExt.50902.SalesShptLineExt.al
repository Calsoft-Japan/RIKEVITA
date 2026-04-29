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
    }
}
