/// <summary>
/// PageExtension RV_CustLedgerEntry (ID 50906) extends "Customer Ledger Entries"
/// FDD009 2026/04/29: New. (Shawn) 
/// </summary>
pageextension 50906 "RV_CustLedgerEntry Ext" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Original Amount")
        {
            field("RV_Freight Charge"; Rec."RV_Freight Charge")
            {
                Caption = 'Freight Charge';
                ApplicationArea = All;
            }
        }
    }
}
