query 50101 "RV Query Item Tracking Hist"
{
    Caption = 'RV Query Item Tracking Hist';
    QueryType = Normal;

    elements
    {
        dataitem(RVItemTrackingHistoryDtl; "Item Entry Relation")
        {

            DataItemTableFilter = "Source Type" = const(Database::"Sales Shipment Line");
            column(LotNo; "Lot No.")
            {
            }
            column(SalesOrderLineNo; "Order Line No.")
            {
            }
            column(SalesOrderNo; "Order No.")
            {
            }

            dataitem(Item_Ledger_Entry; "Item Ledger Entry")
            {
                DataItemLink = "Entry No." = RVItemTrackingHistoryDtl."Item Entry No.";
                SqlJoinType = InnerJoin;
                column(RV_Container_No_; "RV_Container No.")
                { }
                column(QtyperUOM; "Qty. per Unit of Measure")
                { }
                column(Quantity; "Quantity")
                {
                    Method = Sum;
                }
            }
        }
    }


    trigger OnBeforeOpen()
    begin

    end;
}
