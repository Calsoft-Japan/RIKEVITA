/// <summary>
/// TableExtension Customer Ext (ID 50900)
/// FDD009 2026/04/29: New. (Shawn)
/// FDD024 2026/04/29: Liuyang
/// </summary>
tableextension 50900 "RV Customer Ext" extends Customer
{
    fields
    {
        field(50100; "RV_Customer Type"; Enum "RV Customer Type")
        {
            Description = 'FDD024';
            Caption = 'Customer Type';
        }
        field(50900; "RV_Charge Type"; Enum "RV Charge Type")
        {
            Description = 'FDD009';
            Caption = 'Charge Type';
        }
    }
}
