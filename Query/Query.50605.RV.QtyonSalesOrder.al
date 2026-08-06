query 50605 "RV Qty. on Sales Order"
{
    Caption = 'RV Qty. on Sales Order';
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = "Document Type" = const(Order),
                                    Type = const(Item);
            column(ItemNo; "No.")
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
