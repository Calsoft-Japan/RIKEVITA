/// <summary>
/// Query RV Qty. in Transit (ID 50611)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50611 "RV Qty. in Transit"
{
    Caption = 'RV Qty. in Transit';
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
            filter(RV_InTransitLocation; RV_InTransitLocation)
            {
                ColumnFilter = RV_InTransitLocation = const(RV_InTransitLocation::Stock);
            }
            column(Quantity; "Qty. in Transit (Base)")
            {
                method = Sum;
            }
        }
    }
}
