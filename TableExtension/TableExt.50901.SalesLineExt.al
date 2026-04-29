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
    }
}
