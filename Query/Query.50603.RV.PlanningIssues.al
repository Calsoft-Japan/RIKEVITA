/// <summary>
/// Query RV Planning Issues (ID 50603)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50603 "RV Planning Issues"
{
    Caption = 'RV Planning Issues';
    QueryType = Normal;

    elements
    {
        dataitem(ProdOrderComponent; "Planning Component")
        {
            DataItemTableFilter = "Planning Line Origin" = const(" ");
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
            column(Quantity; "Expected Quantity (Base)")
            {
                method = Sum;
            }
        }
    }
}
