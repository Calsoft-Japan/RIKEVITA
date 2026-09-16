/// <summary>
/// Query RV Trans. Ord. Shipment (ID 50606)
/// FDD006 2026/05/17: New. (Stephen)
/// </summary>
query 50606 "RV Trans. Ord. Shipment"
{
    Caption = 'RV Trans. Ord. Shipment';
    QueryType = Normal;

    elements
    {
        dataitem(TransferLine; "Transfer Line")
        {
            DataItemTableFilter = "Derived From Line No." = const(0);
            column(ItemNo; "Item No.")
            {
            }
            filter(ShipmentDate; "Shipment Date")
            {
            }
            filter(RV_TransferfromLocation; RV_TransferfromLocation)
            {
                ColumnFilter = RV_TransferfromLocation = const(RV_TransferfromLocation::Stock);
            }
            column(Quantity; "Outstanding Qty. (Base)")
            {
                method = Sum;
            }
        }
    }
}
