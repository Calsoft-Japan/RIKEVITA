/// <summary>
/// Query RV Qty. on Sales Return (ID 50612)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50612 "RV Qty. on Sales Return"
{
    Caption = 'RV Qty. on Sales Return';
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = "Document Type" = const("Return Order"),
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
