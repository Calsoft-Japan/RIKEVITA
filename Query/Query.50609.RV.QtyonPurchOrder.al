/// <summary>
/// Query RV Qty. on Purch. Order (ID 50609)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50609 "RV Qty. on Purch. Order"
{
    Caption = 'RV Qty. on Purch. Order';
    QueryType = Normal;

    elements
    {
        dataitem(PurchLine; "Purchase Line")
        {
            DataItemTableFilter = "Document Type" = const(Order),
                                    Type = const(Item);
            column(ItemNo; "No.")
            {
            }
            filter(ExpectedReceiptDate; "Expected Receipt Date")
            {
            }
            filter(RV_TranistLocation; RV_TranistLocation)
            {
                ColumnFilter = RV_TranistLocation = Const(RV_TranistLocation::Stock);
            }
            filter(RV_TransitBin; RV_TranistBin)
            {
                // ColumnFilter = RV_TransitBin = Const(RV_TransitBin::"Goods In Transit");
            }
            column(Quantity; "Outstanding Qty. (Base)")
            {
                method = Sum;
            }
        }
    }
}
