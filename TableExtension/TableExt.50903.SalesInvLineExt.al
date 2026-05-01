/// <summary>
/// TableExtension Sales Invoice Line Ext (ID 50903)
/// FDD009 2026/04/29: New. (Shawn)
/// </summary>
tableextension 50903 "RV SalesInvLine Ext" extends "Sales Invoice Line"
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
    }
}
