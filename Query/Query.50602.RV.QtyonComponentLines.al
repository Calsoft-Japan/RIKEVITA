/// <summary>
/// Query RV Qty. on Component Lines (ID 50602)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50602 "RV Qty. on Component Lines"
{
    Caption = 'RV Qty. on Component Lines';
    QueryType = Normal;

    elements
    {
        dataitem(ProdOrderComponent; "Prod. Order Component")
        {
            DataItemTableFilter = status = filter(Planned .. Released);
            column(ItemNo; "Item No.")
            {
            }
            filter(DueDate; "Due Date")
            {
            }
            filter(RV_TranistLocation; RV_TranistLocation)
            {
                ColumnFilter = RV_TranistLocation = const(RV_TranistLocation::Stock);
            }
            column(Quantity; "Remaining Qty. (Base)")
            {
                method = Sum;
            }
        }
    }
}
