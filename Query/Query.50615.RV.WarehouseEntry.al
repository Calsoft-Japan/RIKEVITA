/// <summary>
/// Query RV Warehouse Entry (ID 50615)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50615 "RV Warehouse Entry"
{
    Caption = 'RV Warehouse Entry';
    QueryType = Normal;

    elements
    {
        dataitem(WarehouseEntry; "Warehouse Entry")
        {
            column(ItemNo; "Item No.")
            {
            }
            filter(RV_TranistLocation; RV_TranistLocation)
            {
                ColumnFilter = RV_TranistLocation = Const(RV_TranistLocation::Stock);
            }
            filter(RV_TransitBin; RV_TranistBin)
            {
                ColumnFilter = RV_TransitBin = Const(RV_TransitBin::"Goods In Transit");
            }
            column(Quantity; "Qty. (Base)")
            {
                method = Sum;
            }
        }
    }
}
