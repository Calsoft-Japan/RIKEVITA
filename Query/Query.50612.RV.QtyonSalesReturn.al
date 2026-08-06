query 50612 "RV Qty. on Sales Return"
{
    Caption = 'RV Qty. on Sales Return';
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = "Document Type" = const("Return Order"),
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
