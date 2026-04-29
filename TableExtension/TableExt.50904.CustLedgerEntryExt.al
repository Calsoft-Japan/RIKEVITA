/// <summary>
/// TableExtension Cust. Ledger Entry Ext (ID 50904)
/// FDD009 2026/04/29: New. (Shawn)
/// </summary>
tableextension 50904 "RV CustLedgerEntry Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50900; "RV_Freight Charge"; Decimal)
        {
            Description = 'FDD009';
            Caption = 'Freight Charge';
        }
    }
}
