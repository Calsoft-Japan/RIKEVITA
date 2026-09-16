/// <summary>
/// Query RV Reserved Qty. on Inventory (ID 50616)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50616 "RV Reserved Qty. on Inventory"
{
    Caption = 'RV Reserved Qty. on Inventory';
    QueryType = Normal;

    elements
    {
        dataitem(ReservationEntry; "Reservation Entry")
        {
            DataItemTableFilter = "Source Type" = const(32),
                                "Source Subtype" = const("0"),
                                "Reservation Status" = const(Reservation);
            column(ItemNo; "Item No.")
            {
            }
            filter(RV_TranistLocation; RV_TranistLocation)
            {
                ColumnFilter = RV_TranistLocation = Const(RV_TranistLocation::Stock);
            }
            column(Quantity; "Quantity (Base)")
            {
                method = Sum;
            }
        }
    }
}
