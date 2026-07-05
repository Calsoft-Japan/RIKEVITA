/// <summary>
/// RV Query SO Detail(ID 50103).
/// FDD005 2026/07/03: New. (Liuyang)
/// </summary>
query 50103 "RV Query SO Detail"
{
    Caption = 'RV Query SO Detail';
    QueryType = Normal;
    UsageCategory = ReportsAndAnalysis;
    QueryCategory = 'FDD005';

    elements
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = const("Sales Document Type"::Order);

            column(SO_No_; "No.") { }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }

            dataitem(Sales_Line; "Sales Line")
            {
                DataItemLink = "Document No." = SalesHeader."No.", "Document Type" = SalesHeader."Document Type";

                column(SO_Line_No_; "Line No.")
                { }
                column(Item_No_; "No.")
                { }


                dataitem(Posted_Whse__Shipment_Line; "Posted Whse. Shipment Line")
                {
                    DataItemLink = "Source No." = Sales_Line."Document No.", "Source Line No." = Sales_Line."Line No.", "Item No." = Sales_Line."No.";
                    //DataItemTableFilter = "Source Type" = const(Database::"Sales Line"); //filter here will cz there is no empty right record for left join
                    SqlJoinType = LeftOuterJoin;

                    filter(Source_Type; "Source Type")
                    {
                        ColumnFilter = Source_Type = filter(0 | 37);//Database::"Sales Line" or don't have shipment (LEFT JOIN)
                    }
                    column(Posted_Whse_Shipmentt_No_; "No.") { }

                    column(Whse__Shipment_No_; "Whse. Shipment No.") { }

                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
