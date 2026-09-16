/// <summary>
/// Query RV Trans. Ord. Receipt (ID 50610)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50610 "RV Trans. Ord. Receipt"
{
    Caption = 'RV Trans. Ord. Receipt';
    QueryType = Normal;

    elements
    {
        dataitem(TransferLine; "Transfer Line")
        {
            DataItemTableFilter = "Derived From Line No." = const(0);
            column(ItemNo; "Item No.")
            {
            }
            filter(ReceiptDate; "Receipt Date")
            {
            }
            filter(RV_TransfertoLocation; RV_TransfertoLocation)
            {
                ColumnFilter = RV_TransfertoLocation = const(RV_TransfertoLocation::Stock);
            }
            column(Quantity; "Outstanding Qty. (Base)")
            {
                method = Sum;
            }
        }
    }
}
