/// <summary>
/// RV Query SO Ship Summery (ID 50102).
/// FDD005 2026/07/03: New. (Liuyang)
/// </summary>
query 50102 "RV Query SO Ship Summery"
{
    Caption = 'RV Query SO Ship Summery';
    QueryType = Normal;
    UsageCategory = ReportsAndAnalysis;
    QueryCategory = 'FDD005';

    elements
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = const("Sales Document Type"::Order);

            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }

            dataitem(Sales_Line; "Sales Line")
            {
                DataItemLink = "Document No." = SalesHeader."No.", "Document Type" = SalesHeader."Document Type";

                column(Item_No_; "No.")
                { }

                column(SO_Quantity_SUM; Quantity)
                {
                    Method = Sum;
                }

                dataitem(Posted_Whse__Shipment_Line; "Posted Whse. Shipment Line")
                {
                    DataItemLink = "Source No." = Sales_Line."Document No.", "Source Line No." = Sales_Line."Line No.", "Item No." = Sales_Line."No.";
                    //DataItemTableFilter = "Source Type" = const(Database::"Sales Line"); //filter here will cz there is no empty right record for left join
                    SqlJoinType = LeftOuterJoin;
                    //column(Shpt_Item_No_; "Item No.") { }
                    filter(Source_Type; "Source Type")
                    {
                        ColumnFilter = Source_Type = filter(0 | 37);//Database::"Sales Line" or don't have shipment (LEFT JOIN)
                    }
                    column(Ship_Quantity_SUM; Quantity)
                    {
                        Method = Sum;
                    }

                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
