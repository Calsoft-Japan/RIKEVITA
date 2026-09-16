/// <summary>
/// Query RV Planning Tran. Ship (ID 50604)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50604 "RV Planning Tran. Ship"
{
    Caption = 'RV Planning Tran. Ship';
    QueryType = Normal;

    elements
    {
        dataitem(RequisitionLine; "Requisition Line")
        {
            DataItemTableFilter = "Worksheet Template Name" = filter(<> ''),
                                    "Journal Batch Name" = filter(<> ''),
                                    "Replenishment System" = const(Transfer),
                                    Type = const(Item);
            column(ItemNo; "No.")
            {
            }
            filter(TransferShipmentDate; "Transfer Shipment Date")
            {
            }
            filter(RV_TranistLocation; RV_TranistFromLocation)
            {
                ColumnFilter = RV_TranistLocation = const(RV_TranistLocation::Stock);
            }
            column(Quantity; "Quantity (Base)")
            {
                method = Sum;
            }
        }
    }
}
