/// <summary>
/// pageextension Sales Order Ext (ID 50108) extends "Sales Order" page
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
pageextension 50108 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addlast(factboxes)
        {
            // ── Factbox 1: Shipping History Summary ───────────────────────
            part(ShippingHistorySummaryFB; "Shipping History Summary")
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
            part(ItemTrackingHistoryFB; "Item Tracking History - Sales")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Item Tracking History - Sales';
                Provider = SalesLines;
                // "Order No." on ILE = originating Sales Order No.
                // "Item No."  on ILE = item number from the selected Sales Line.
                SubPageLink = "Order No." = FIELD("Document No."),
                              "Item No." = FIELD("No.");
            }
        }
    }
}
