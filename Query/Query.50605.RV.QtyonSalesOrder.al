/// <summary>
/// Query RV Qty. on Sales Order (ID 50605)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50605 "RV Qty. on Sales Order"
{
    Caption = 'RV Qty. on Sales Order';
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = "Document Type" = const(Order),
                                    Type = const(Item);
            column(ItemNo; "No.")
            {
            }
            filter(ShipmentDate; "Shipment Date")
            {
            }
            filter(RV_TranistLocation; RV_TranistLocation)
            {
                ColumnFilter = RV_TranistLocation = const(RV_TranistLocation::Stock);
            }
            column(Quantity; "Outstanding Qty. (Base)")
            {
                method = Sum;
            }
        }
    }
}
