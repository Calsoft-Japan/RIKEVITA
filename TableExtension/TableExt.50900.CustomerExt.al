/// <summary>
/// TableExtension Customer Ext (ID 50900)
/// FDD009 2026/04/29: New. (Shawn)
/// </summary>
tableextension 50900 "RV Customer Ext" extends Customer
{
    fields
    {
        field(50900; "RV_Charge Type"; Enum "RV Charge Type")
        {
            Description = 'FDD009';
            Caption = 'Charge Type';
        }
    }
}
