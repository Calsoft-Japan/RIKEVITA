/// <summary>
/// Page Shipping History Summary (ID 50104).
/// FDD005 2026/03/09: New. (Liuyang)
/// </summary>
page 50104 "RV Shipping History Summary"
{
    ApplicationArea = All;
    Caption = 'Shipping History Summary';
    PageType = CardPart;
    SourceTable = "Sales Line";
    Editable = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(ShippingInfo)
            {
                ShowCaption = false;

                field(TotalOrderQty; TotalOrderQty)
                {
                    ApplicationArea = All;
                    Caption = 'Total Order Qty.';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the quantity ordered in the most recent posted sales orders for this item.';
                    trigger OnDrillDown()
                    var
                        SOLine: Record "Sales Line";
                        SOLines_PG: Page "Sales Lines";
                    begin
                        if SONoFilter = '' then
                            exit;

                        SOLine.Reset();
                        SOLine.SetRange("Document Type", "Sales Document Type"::Order);
                        SOLine.SetRange(Type, "Sales Line Type"::Item);
                        SOLine.SetRange("No.", Rec."No.");
                        //SOLine.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");

                        if SONoFilter <> '' then
                            SOLine.SetFilter("Document No.", SONoFilter);

                        SOLines_PG.SetTableView(SOLine);
                        SOLines_PG.RunModal();
                    end;
                }
                field(TotalShptQty; TotalShptQty)
                {
                    ApplicationArea = All;
                    Caption = 'Total Shipped Qty.';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the quantity shipped in the most recent posted warehouse shipment for this item.';
                    trigger OnDrillDown()
                    begin
                        WhseShptDrillDown();
                    end;
                }
                field(TotalBalanceQty; TotalBalanceQty)
                {
                    ApplicationArea = All;
                    Caption = 'Balance Quantity';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the balance quantity between ordered and shipped for this item.';
                    trigger OnDrillDown()
                    begin
                        WhseShptDrillDown();
                    end;
                }

                // ── No. of Posted Shipment ─────────────────────────────────
                // DrillDown opens Posted Whse. Shipment Lines filtered by
                // Sales Order No. and Item No.
                field(NoOfPostedShipments; NoOfPostedShipments)
                {
                    ApplicationArea = All;
                    Caption = 'No. of Posted Shipment';
                    DrillDown = true;
                    ToolTip = 'Specifies the total number of posted warehouse shipments for this item on the sales order. Click to view the full list.';

                    /* trigger OnDrillDown()
                    var
                        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
                        PostedWhseShptLinesPage: Page "Posted Whse. Shipment Lines";
                    //PostedWhseShptsPage: page "Posted Whse. Shipment List";
                    begin
                        PostedWhseShptLine.SetRange("Source Type", Database::"Sales Line");
                        //PostedWhseShptLine.SetRange("Source No.", Rec."Document No.");
                        PostedWhseShptLine.SetRange("Item No.", Rec."No.");

                        if PstWhsNoFilter <> '' then
                            PostedWhseShptLine.SetFilter("No.", PstWhsNoFilter);//Posted Warehosue Shipment No.
                        PostedWhseShptLinesPage.SetTableView(PostedWhseShptLine);
                        PostedWhseShptLinesPage.RunModal();
                    end; */
                    trigger OnDrillDown()
                    begin
                        WhseShptDrillDown()
                    end;
                }

                // ── Last Posted Shipment No. ───────────────────────────────
                field(LastPostedShipmentNo; LastPostedShipmentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Last Posted Shipment No.';
                    ToolTip = 'Specifies the document number of the most recent posted warehouse shipment for this item.';
                }

                // ── Quantity ───────────────────────────────────────────────
                // Sourced from the last Posted Whse. Shipment Line.Quantity.
                field(LastQty; LastQty)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the quantity shipped in the most recent posted warehouse shipment for this item.';
                }

                // ── Shipment Method ────────────────────────────────────────
                // Sourced from Posted Whse. Shipment Header."Shipment Method Code"
                // for the header matching the last shipment line.
                field(LastShipmentMethodCode; LastShipmentMethodCode)
                {
                    ApplicationArea = All;
                    Caption = 'Shipment Method';
                    ToolTip = 'Specifies the shipment method of the most recent posted warehouse shipment.';
                }

                // ── Location Code ──────────────────────────────────────────
                // Sourced from the last Posted Whse. Shipment Line."Location Code".
                field(LastLocationCode; LastLocationCode)
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                    ToolTip = 'Specifies the warehouse location of the most recent posted warehouse shipment for this item.';
                }

                // ── Posting Date ───────────────────────────────────────────
                // Sourced from Posted Whse. Shipment Header."Posting Date"
                // for the header matching the last shipment line.
                field(LastPostingDate; LastPostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date of the most recent posted warehouse shipment for this item.';
                }
            }
        }
    }

    var
        NoOfPostedShipments: Integer;
        LastPostedShipmentNo: Code[20];
        LastQty: Decimal;
        LastShipmentMethodCode: Code[10];
        LastLocationCode: Code[10];
        LastPostingDate: Date;
        TotalOrderQty: Decimal;
        TotalShptQty: Decimal;
        TotalBalanceQty: Decimal;
        PstWhsNoFilter: Text;
        SONoFilter: Text;

    trigger OnAfterGetRecord()
    begin
        CalcShippingHistorySummary();
    end;

    procedure WhseShptDrillDown()
    var
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        PostedWhseShptLinesPage: Page "Posted Whse. Shipment Lines";
    //PostedWhseShptsPage: page "Posted Whse. Shipment List";
    begin
        if PstWhsNoFilter = '' then
            exit;

        PostedWhseShptLine.SetRange("Source Type", Database::"Sales Line");
        //PostedWhseShptLine.SetRange("Source No.", Rec."Document No.");
        PostedWhseShptLine.SetRange("Item No.", Rec."No.");

        PostedWhseShptLine.SetFilter("No.", PstWhsNoFilter);//Posted Warehosue Shipment No.
        PostedWhseShptLinesPage.SetTableView(PostedWhseShptLine);
        PostedWhseShptLinesPage.RunModal();
    end;
    // ── Core aggregation procedure ─────────────────────────────────────────
    local procedure CalcShippingHistorySummary()
    var
        SOHeader: Record "Sales Header";
        SOLines: Record "Sales Line";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        QrySOShipSum: Query "RV Query SO Ship Summery";
        QrySOShptDtl: Query "RV Query SO Detail";
        PostShtList: List of [Text];
        DistPstShpts: Dictionary of [Text, Integer];
        DistSONoList: List of [Text];
        ExtDocNo: Text;
        ComboKey: Text;
        CurCnt: Integer;
    begin
        ClearSummaryVars();

        // Skip calculation if the Sales Line has no item (e.g. comment lines).
        if Rec."No." = '' then
            exit;

        Clear(PostShtList);
        SOHeader.Reset();
        SOHeader.SetRange("Document Type", Rec."Document Type");
        SOHeader.SetRange("No.", Rec."Document No.");
        if SOHeader.FindSet() then
            ExtDocNo := SOHeader."External Document No.";

        QrySOShipSum.SetRange(ExternalDocumentNo, ExtDocNo);
        QrySOShipSum.SetRange(SelltoCustomerNo, Rec."Sell-to Customer No.");
        QrySOShipSum.SetRange(Item_No_, Rec."No.");
        QrySOShipSum.Open();
        while QrySOShipSum.Read() do begin
            TotalOrderQty := QrySOShipSum.SO_Quantity_SUM;
            TotalShptQty := QrySOShipSum.Ship_Quantity_SUM;
            TotalBalanceQty := TotalOrderQty - TotalShptQty;

            ComboKey := ExtDocNo + '|' + Rec."Sell-to Customer No." + '|' + Rec."No.";
            if not PostShtList.Contains(ComboKey) then
                PostShtList.Add(ComboKey);
        end;
        QrySOShipSum.Close();


        Clear(DistPstShpts);
        Clear(PstWhsNoFilter);
        Clear(SONoFilter);
        QrySOShptDtl.SetRange(ExternalDocumentNo, ExtDocNo);
        QrySOShptDtl.SetRange(SelltoCustomerNo, Rec."Sell-to Customer No.");
        QrySOShptDtl.SetRange(Item_No_, Rec."No.");
        QrySOShptDtl.Open();
        while QrySOShptDtl.Read() do begin
            if QrySOShptDtl.Posted_Whse_Shipmentt_No_ <> '' then begin
                if not DistPstShpts.ContainsKey(QrySOShptDtl.Posted_Whse_Shipmentt_No_) then begin
                    DistPstShpts.Add(QrySOShptDtl.Posted_Whse_Shipmentt_No_, 1);
                    PstWhsNoFilter := PstWhsNoFilter + QrySOShptDtl.Posted_Whse_Shipmentt_No_ + '|';
                end
                else begin
                    CurCnt := DistPstShpts.Get(QrySOShptDtl.Posted_Whse_Shipmentt_No_);
                    DistPstShpts.Set(QrySOShptDtl.Posted_Whse_Shipmentt_No_, CurCnt + 1);
                end;
            end;

            if QrySOShptDtl.SO_No_ <> '' then begin
                if not DistSONoList.Contains(QrySOShptDtl.SO_No_) then begin
                    DistSONoList.Add(QrySOShptDtl.SO_No_);
                    SONoFilter := SONoFilter + QrySOShptDtl.SO_No_ + '|';
                end;
            end;
        end;
        QrySOShipSum.Close();
        NoOfPostedShipments := DistPstShpts.Count;
        if PstWhsNoFilter <> '' then
            PstWhsNoFilter := PstWhsNoFilter.Remove(StrLen(PstWhsNoFilter));
        if SONoFilter <> '' then
            SONoFilter := SONoFilter.Remove(StrLen(SONoFilter));

        PostedWhseShptLine.SetRange("Source Type", Database::"Sales Line");
        PostedWhseShptLine.SetRange("Item No.", Rec."No.");
        if not PostedWhseShptLine.FindSet() then begin
            exit;
        end;
        /* Clear(PostShtList);
        repeat
            if not PostShtList.Contains(PostedWhseShptLine."No.") then
                PostShtList.Add(PostedWhseShptLine."No.");
        until PostedWhseShptLine.Next() = 0;
        NoOfPostedShipments := PostShtList.Count; */

        // Filter all Posted Whse. Shipment Lines for this Sales Order + Item.
        PostedWhseShptLine.SetRange("Source No.", Rec."Document No.");
        PostedWhseShptLine.SetRange("Source Line No.", Rec."Line No.");

        if PostedWhseShptLine.FindLast() then begin
            LastPostedShipmentNo := PostedWhseShptLine."No.";
            LastQty := PostedWhseShptLine.Quantity;
            LastLocationCode := PostedWhseShptLine."Location Code";

            // Posting Date and Shipment Method Code are header-level fields.
            // Retrieve the matching header using the line's document number.
            if PostedWhseShptHeader.Get(PostedWhseShptLine."No.") then begin
                LastPostingDate := PostedWhseShptHeader."Posting Date";
                LastShipmentMethodCode := PostedWhseShptHeader."Shipment Method Code";
            end;
        end;
    end;

    local procedure ClearSummaryVars()
    begin
        NoOfPostedShipments := 0;
        LastPostedShipmentNo := '';
        LastQty := 0;
        LastShipmentMethodCode := '';
        LastLocationCode := '';
        LastPostingDate := 0D;
    end;
}
