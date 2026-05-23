/// <summary>
/// pageextension Sales Order Ext (ID 50108) extends "Sales Order" page
/// FDD005 2026/03/14: New. (Liuyang)
/// FDD012 2026/04/19 Liuyang
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

                /* SubPageLink = "Source Type" = const(Database::"Sales Shipment Line"),
                              "Order No." = FIELD("Document No."),
                              "Order Line No." = FIELD("Line No."); */
                SubPageLink = "Sales Order No." = FIELD("Document No."),
                              "Sales Order Line No." = FIELD("Line No.");


            }
        }

        addlast(Control90)//FDD012
        {
            group(FDD012)
            {
                ShowCaption = false;

                field("RV_B/L Date"; Rec."RV_B/L Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD012';
                    Editable = AllowBLDate;
                }
                field("RV_Cosing Date"; Rec."RV_Cosing Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD012';
                    Editable = AllowClosingDate;
                }
                field("RV_Stuffing Date"; Rec."RV_Stuffing Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD012';
                    Editable = AllowStaffingDate;
                }
                field(RV_ETD; Rec."RV_ETD")
                {
                    ApplicationArea = All;
                    Description = 'FDD012';
                }
                field(RV_ETA; Rec."RV_ETA")
                {
                    ApplicationArea = All;
                    Description = 'FDD012';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PermissionCheck: Codeunit "RV User Permission Check";
        QryItemTrack: Query "RV Query Item Tracking Hist";
        RVItemTrackHist: Record "RV Item Tracking History Dtl.";
    begin
        PermissionCheck.GetCurUserPermission(AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate);

        //FDD005
        RVItemTrackHist.LockTable();
        QryItemTrack.SetRange(SalesOrderNo, Rec."No.");
        //QryItemTrack.SetRange(SalesOrderLineNo, SOLine."Line No.");
        QryItemTrack.Open();
        while QryItemTrack.Read() do begin
            RVItemTrackHist.Init();
            RVItemTrackHist."Sales Order No." := QryItemTrack.SalesOrderNo;
            RVItemTrackHist."Sales Order Line No." := QryItemTrack.SalesOrderLineNo;
            RVItemTrackHist."Lot No." := QryItemTrack.LotNo;
            RVItemTrackHist."Container No." := QryItemTrack.RV_Container_No_;
            RVItemTrackHist.Qty := QryItemTrack.Quantity / QryItemTrack.QtyperUOM;
            if not RVItemTrackHist.Insert() then
                RVItemTrackHist.Modify();
        end;
        QryItemTrack.Close();
    end;

    var
        AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate : Boolean;
}
