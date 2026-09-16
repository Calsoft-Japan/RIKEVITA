/// <summary>
/// Query RV Scheduled Receipt (ID 50608)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50608 "RV Scheduled Receipt"
{
    Caption = 'RV Scheduled Receipt';
    QueryType = Normal;

    elements
    {
        dataitem(ProdLine; "Prod. Order Line")
        {
            DataItemTableFilter = Status = filter("Firm Planned" | Released);
            column(ItemNo; "Item No.")
            {
            }
            filter(DueDate; "Due Date")
            {
            }
            filter(RV_TranistLocation; RV_TranistLocation)
            {
                ColumnFilter = RV_TranistLocation = Const(RV_TranistLocation::Stock);
            }
            column(Quantity; "Remaining Qty. (Base)")
            {
                method = Sum;
            }
        }
    }
}
