query 50604 "RV Planning Tran. Ship"
{
    Caption = 'RV Planning Tran. Ship';
    QueryType = Normal;

    elements
    {
        dataitem(RequisitionLine; "Requisition Line")
        {
            DataItemTableFilter = "Worksheet Template Name" = filter(<> ''),
                                    "Journal Batch Name" = filter(<> ''),
                                    "Replenishment System" = const(Transfer),
                                    Type = const(Item);
            column(ItemNo; "No.")
            {
            }
            filter(TransferShipmentDate; "Transfer Shipment Date")
            {
            }
            column(Quantity; "Quantity (Base)")
            {
                method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
