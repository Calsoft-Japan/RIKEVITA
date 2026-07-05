query 50101 "RV Query Item Tracking Hist"
{
    Caption = 'RV Query Item Tracking Hist';
    QueryType = Normal;

    elements
    {
        // dataitem(RVItemTrackingHistoryDtl; "Item Entry Relation")
        // {

        //     DataItemTableFilter = "Source Type" = const(Database::"Sales Shipment Line");

        //     /* column(SalesOrderLineNo; "Order Line No.")
        //     {
        //     } */
        //     filter(SalesOrderNo; "Order No.")
        //     {
        //     }

        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            // DataItemLink = "Entry No." = RVItemTrackingHistoryDtl."Item Entry No.";
            // SqlJoinType = InnerJoin;
            DataItemTableFilter = "Source Type" = const("Analysis Source Type"::Customer);

            column(External_Document_No_; "External Document No.") { }
            column(CustNo_Source_No_; "Source No.") { }
            column(LotNo; "Lot No.")
            {
            }
            column(RV_Container_No_; "RV_Container No.")
            { }
            column(QtyperUOM; "Qty. per Unit of Measure")
            { }
            column(Quantity; "Quantity")
            {
                Method = Sum;
            }
            column(Item_No_; "Item No.")
            { }
        }

        // }
    }


    trigger OnBeforeOpen()
    begin

    end;
}
