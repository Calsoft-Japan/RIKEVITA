/// <summary>
/// Query RV Item Inventory Expired (ID 50617)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>

query 50617 "RV Item Inventory Expired"
{
    Caption = 'RV Item Inventory Expired';
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            column(ItemNo; "Item No.")
            {
            }
            filter(ExpirationDate; "Expiration Date")
            {
            }
            filter(RV_TranistLocation; RV_TranistLocation)
            {
                ColumnFilter = RV_TranistLocation = const(RV_TranistLocation::Stock);
            }
            column(Quantity; Quantity)
            {
                method = Sum;
            }
        }
    }
}
