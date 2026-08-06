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
            column(Quantity; "Outstanding Qty. (Base)")
            {
                method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
