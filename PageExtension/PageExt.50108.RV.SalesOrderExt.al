/// <summary>
/// pageextension Sales Order Ext (ID 50108) extends "Sales Order" page
/// FDD005 2026/03/14: New. (Liuyang)
/// </summary>
pageextension 50108 "RV Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addlast(factboxes)
        {
            // ── Factbox 1: Shipping History Summary ───────────────────────
            part(ShippingHistorySummaryFB; "RV Shipping History Summary")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Shipping History Summary';
                Provider = SalesLines;
                SubPageLink = "Document Type" = CONST(Order),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }

            // ── Factbox 2: Item Tracking History ──────────────────────────
            part(ItemTrackingHistoryFB; "RV Item Tracking Hst. - Sales")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Item Tracking History Details';
                Provider = SalesLines;
                // "Order No." on Sales Shipment Line(Posted) = originating Sales Order No.
                // "Order Line No."  on Sales Shipment Line(Posted) = line no. from the selected Sales Line.
                SubPageLink = "Order No." = FIELD("Document No."),
                              "Order Line No." = FIELD("Line No.");

            }
        }
    }
}
