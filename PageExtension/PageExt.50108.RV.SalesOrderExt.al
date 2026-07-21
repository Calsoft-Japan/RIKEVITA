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

                /* SubPageLink = "Sales Order No." = FIELD("Document No."),
                              "Sales Order Line No." = FIELD("Line No."); */
                SubPageLink = "External Document No." = field("External Document No."),
                              "Sell-to Customer No." = field("Sell-to Customer No."),
                              "Item No." = field("No.");


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
                field("RV_Cosing Date"; Rec."RV_Closing Date")
                {
                    ApplicationArea = All;
                    Description = 'FDD012';
                    Editable = AllowClosingDate;
                }
                field("RV_RDD"; Rec."RV_RDD")
                {
                    ApplicationArea = All;
                    Description = 'FDD006';
                    Editable = AllowStaffingDate;
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

        SOLines: Record "Sales Line";
        //QrySOShptDtl: Query "RV Query SO Detail";
        SONoFilter: Text;
        DistSONoList: List of [Text];
        ExtDocNo: Text;
        ItemNoFilter: Text;
        DistItemNoList: List of [Text];
    begin
        PermissionCheck.GetCurUserPermission(AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate);

        Clear(SONoFilter);
        Clear(DistSONoList);
        Clear(ItemNoFilter);
        Clear(DistItemNoList);
        ExtDocNo := Rec."External Document No.";
        SOLines.Reset();
        SOLines.SetRange("Document Type", Rec."Document Type");
        SOLines.SetRange("Document No.", Rec."No.");
        SOLines.SetRange(Type, "Sales Line Type"::Item);
        SOLines.SetFilter("No.", '<>""');
        if SOLines.FindSet() then begin
            repeat
                SOLines."External Document No." := ExtDocNo;
                SOLines.Modify();

                /* QrySOShptDtl.SetRange(ExternalDocumentNo, ExtDocNo);
                QrySOShptDtl.SetRange(SelltoCustomerNo, SOLines."Sell-to Customer No.");
                QrySOShptDtl.SetRange(Item_No_, SOLines."No.");
                QrySOShptDtl.Open();
                while QrySOShptDtl.Read() do begin
                    if QrySOShptDtl.SO_No_ <> '' then begin
                        if not DistSONoList.Contains(QrySOShptDtl.SO_No_) then begin
                            DistSONoList.Add(QrySOShptDtl.SO_No_);
                            SONoFilter := SONoFilter + QrySOShptDtl.SO_No_ + '|';
                        end;
                    end;
                end;
                QrySOShptDtl.Close(); */

                if not DistItemNoList.Contains(SOLines."No.") then begin
                    DistItemNoList.Add(SOLines."No.");
                    ItemNoFilter := ItemNoFilter + SOLines."No." + '|';
                end;
            until SOLines.Next() = 0;

            /* if SONoFilter <> '' then
                SONoFilter := SONoFilter.Remove(StrLen(SONoFilter)); */

            if ItemNoFilter <> '' then
                ItemNoFilter := ItemNoFilter.Remove(StrLen(ItemNoFilter));
        end;

        //FDD005
        RVItemTrackHist.LockTable();
        //QryItemTrack.SetRange(SalesOrderNo, Rec."No.");
        /* if SONoFilter <> '' then
            QryItemTrack.SetFilter(SalesOrderNo, SONoFilter); */
        //QryItemTrack.SetRange(SalesOrderLineNo, SOLine."Line No.");

        if ItemNoFilter <> '' then
            QryItemTrack.SetFilter(Item_No_, ItemNoFilter);

        QryItemTrack.SetRange(External_Document_No_, Rec."External Document No.");
        QryItemTrack.SetRange(CustNo_Source_No_, Rec."Sell-to Customer No.");

        QryItemTrack.Open();
        while QryItemTrack.Read() do begin
            RVItemTrackHist.Init();
            //RVItemTrackHist."Sales Order No." := QryItemTrack.SalesOrderNo;
            //RVItemTrackHist."Sales Order Line No." := QryItemTrack.SalesOrderLineNo;
            RVItemTrackHist."Lot No." := QryItemTrack.LotNo;
            RVItemTrackHist."Container No." := QryItemTrack.RV_Container_No_;
            RVItemTrackHist.Qty := QryItemTrack.Quantity / QryItemTrack.QtyperUOM;
            RVItemTrackHist."External Document No." := Rec."External Document No.";
            RVItemTrackHist."Sell-to Customer No." := Rec."Sell-to Customer No.";
            RVItemTrackHist."Item No." := QryItemTrack.Item_No_;
            if not RVItemTrackHist.Insert() then
                RVItemTrackHist.Modify();
        end;
        QryItemTrack.Close();
    end;

    var
        AllowContainer, AllowBLDate, AllowClosingDate, AllowStaffingDate : Boolean;
}
