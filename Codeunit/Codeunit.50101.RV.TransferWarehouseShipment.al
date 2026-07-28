/// <summary>
/// Codeunit RIKE Transfer Warehouse Shipment (ID 50101)
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
codeunit 50101 "RV TransferWarehouseShipment"
{
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", OnSalesLineOnAfterCreateShptHeader, '', false, false)]
    local procedure "Get Source Documents_OnSalesLineOnAfterCreateShptHeader"(var WhseShptHeader: Record "Warehouse Shipment Header"; WhseHeaderCreated: Boolean; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; WarehouseRequest: Record "Warehouse Request")
    begin
        WhseShptHeader."RV_B/L Date" := SalesHeader."RV_B/L Date";
        WhseShptHeader."RV_Closing Date" := SalesHeader."RV_Closing Date";
        WhseShptHeader."RV_Stuffing Date" := SalesHeader."RV_Stuffing Date";
        WhseShptHeader.RV_ETD := SalesHeader."RV_ETD";
        WhseShptHeader.RV_ETA := SalesHeader."RV_ETA";
        WhseShptHeader."RV_Shipment Type" := SalesHeader."RV_Shipment Type";//FDD008 Update
        WhseShptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", OnSalesLineOnAfterGetRecordOnBeforeCreateShptHeader, '', false, false)]
    local procedure "Get Source Documents_OnSalesLineOnAfterGetRecordOnBeforeCreateShptHeader"(var Sender: Report "Get Source Documents"; SalesLine: Record "Sales Line"; var WarehouseRequest: Record "Warehouse Request"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WhseHeaderCreated: Boolean; var OneHeaderCreated: Boolean; var IsHandled: Boolean; var ErrorOccured: Boolean; var LinesCreated: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        if OneHeaderCreated and not WhseHeaderCreated then begin
            //OneHeaderCreated := false;
            SalesHeader.Reset();
            if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin

                WarehouseShipmentHeader."External Document No." := SalesHeader."External Document No.";
                WarehouseShipmentHeader."Shipment Method Code" := SalesHeader."Shipment Method Code";
                WarehouseShipmentHeader."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
                WarehouseShipmentHeader."Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
                WarehouseShipmentHeader."Shipment Date" := SalesHeader."Shipment Date";

                WarehouseShipmentHeader."RV_B/L Date" := SalesHeader."RV_B/L Date";
                WarehouseShipmentHeader."RV_Closing Date" := SalesHeader."RV_Closing Date";
                WarehouseShipmentHeader."RV_Stuffing Date" := SalesHeader."RV_Stuffing Date";
                WarehouseShipmentHeader.RV_ETD := SalesHeader."RV_ETD";
                WarehouseShipmentHeader.RV_ETA := SalesHeader."RV_ETA";
                WarehouseShipmentHeader."RV_Shipment Type" := SalesHeader."RV_Shipment Type";//FDD008 Update
                WarehouseShipmentHeader.Modify();

                WhseHeaderCreated := true;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", OnAfterCreateShptLineFromSalesLine, '', false, false)]
    local procedure "Sales Warehouse Mgt._OnAfterCreateShptLineFromSalesLine"(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        WarehouseShipmentLine."RV_B/L Date" := SalesLine."RV_B/L Date";
        WarehouseShipmentLine."RV_Closing Date" := SalesLine."RV_Closing Date";
        WarehouseShipmentLine."RV_Stuffing Date" := SalesLine."RV_Stuffing Date";
        WarehouseShipmentLine.RV_ETD := SalesLine."RV_ETD";
        WarehouseShipmentLine.RV_ETA := SalesLine."RV_ETA";
        WarehouseShipmentLine.Modify();
    end;


    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", OnAfterCreateShptHeader, '', false, false)]
    local procedure "Get Source Documents_OnAfterCreateShptHeader"(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line"; PurchaseLine: Record "Purchase Line")
    var
        SOHeader: Record "Sales Header";
        POHeader: Record "Purchase Header";
    begin
        if WarehouseRequest."Source Document" = "Warehouse Request Source Document"::"Sales Order" then begin
            SOHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
            WarehouseShipmentHeader."RV_B/L Date" := SOHeader."RV_B/L Date";
            WarehouseShipmentHeader."RV_Closing Date" := SOHeader."RV_Closing Date";
            WarehouseShipmentHeader."RV_Stuffing Date" := SOHeader."RV_Stuffing Date";
            WarehouseShipmentHeader.RV_ETD := SOHeader."RV_ETD";
            WarehouseShipmentHeader.RV_ETA := SOHeader."RV_ETA";
            WarehouseShipmentHeader."RV_Shipment Type" := SOHeader."RV_Shipment Type";//FDD008 Update
            WarehouseShipmentHeader.Modify();
        end;

        if WarehouseRequest."Source Document" = "Warehouse Request Source Document"::"Purchase Order" then begin
            POHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            WarehouseShipmentHeader.RV_ETD := POHeader."RV_ETD";
            WarehouseShipmentHeader.RV_ETA := POHeader."RV_ETA";
            WarehouseShipmentHeader.Modify();
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeInsertItemLedgEntry, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnBeforeInsertItemLedgEntry"(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLineOrigin: Record "Item Journal Line")
    begin
        ItemLedgerEntry."RV_Container No." := ItemJournalLine."RV_Container No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeItemJnlPostLine, '', false, false)]
    local procedure "Sales-Post_OnBeforeItemJnlPostLine"(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary)
    var
        WhsShipmentLine: Record "Warehouse Shipment Line";
        ResvEntry: Record "Reservation Entry";
    begin
        /* WhsShipmentLine.Reset();
        WhsShipmentLine.SetRange("Source Type", Database::"Sales Line");
        WhsShipmentLine.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
        WhsShipmentLine.SetRange("Source No.", SalesLine."Document No.");
        WhsShipmentLine.SetRange("Source Line No.", SalesLine."Line No.");
        if WhsShipmentLine.FindFirst() then begin
            ResvEntry.Reset();
            ResvEntry.SetRange("Source Type", Database::"Sales Line");
            ResvEntry.SetRange("Source Subtype", 1);
            ResvEntry.SetRange("Source ID", SalesLine."Document No.");
            ResvEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
            ResvEntry.ReadIsolation(IsolationLevel::ReadUncommitted);
            if ResvEntry.FindFirst() then
                ItemJournalLine."RV_Container No." := ResvEntry."RV_Container No.";
        end; */
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnPostItemJnlLineOnBeforeItemJnlPostLineRunWithCheck, '', false, false)]
    local procedure "Purch.-Post_OnPostItemJnlLineOnBeforeItemJnlPostLineRunWithCheck"(var ItemJnlLine: Record "Item Journal Line"; var PurchaseLine: Record "Purchase Line"; DropShipOrder: Boolean; PurchaseHeader: Record "Purchase Header"; WhseReceive: Boolean; QtyToBeReceived: Decimal; QtyToBeReceivedBase: Decimal; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; var IsHandled: Boolean)
    var
        WhsShipmentLine: Record "Warehouse Shipment Line";
        ResvEntry: Record "Reservation Entry";
    begin
        /* WhsShipmentLine.Reset();
        WhsShipmentLine.SetRange("Source Type", Database::"Purchase Line");
        WhsShipmentLine.SetRange("Source Subtype", PurchaseLine."Document Type".AsInteger());
        WhsShipmentLine.SetRange("Source No.", PurchaseLine."Document No.");
        WhsShipmentLine.SetRange("Source Line No.", PurchaseLine."Line No.");
        if WhsShipmentLine.FindFirst() then begin
            ResvEntry.SetRange("Source Type", Database::"Purchase Line");
            ResvEntry.SetRange("Source Subtype", PurchaseLine."Document Type".AsInteger());
            ResvEntry.SetRange("Source ID", PurchaseLine."Document No.");
            ResvEntry.SetRange("Source Ref. No.", PurchaseLine."Line No.");
            ResvEntry.ReadIsolation(IsolationLevel::ReadUncommitted);
            if ResvEntry.FindFirst() then
                ItemJnlLine."RV_Container No." := ResvEntry."RV_Container No.";
        end; */
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnRunWithCheckOnAfterRetrieveItemTracking, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnRunWithCheckOnAfterRetrieveItemTracking"(var ItemJournalLine: Record "Item Journal Line"; var TempTrackingSpecification: Record "Tracking Specification"; var TrackingSpecExists: Boolean; PostponeReservationHandling: Boolean)
    begin
        ItemJournalLine."RV_Container No." := TempTrackingSpecification."RV_Container No.";
    end;


    //FDD005 Item Tracking History Details
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnInsertShptEntryRelationOnAfterItemEntryRelationInsert, '', false, false)]
    local procedure "Sales-Post_OnInsertShptEntryRelationOnAfterItemEntryRelationInsert"(SalesShipmentLine: Record "Sales Shipment Line"; var ItemEntryRelation: Record "Item Entry Relation"; xSalesLine: Record "Sales Line")
    var
        ItemTrackHist: Record "RV Item Tracking History Dtl.";
        ILE: Record "Item Ledger Entry";
    begin
        ILE.SetRange("Entry No.", ItemEntryRelation."Item Entry No.");
        if not ILE.FindFirst() then exit;

        ItemTrackHist.LockTable();

        ItemTrackHist.Reset();
        //ItemTrackHist.SetRange("Sales Order No.", xSalesLine."Document No.");
        //ItemTrackHist.SetRange("Sales Order Line No.", xSalesLine."Line No.");

        ItemTrackHist.SetRange("External Document No.", xSalesLine."External Document No.");
        ItemTrackHist.SetRange("Sell-to Customer No.", xSalesLine."Sell-to Customer No.");
        ItemTrackHist.SetRange("Item No.", xSalesLine."No.");
        ItemTrackHist.SetRange("Lot No.", ItemEntryRelation."Lot No.");
        ItemTrackHist.SetRange("Container No.", ILE."RV_Container No.");
        if ItemTrackHist.FindFirst() then begin
            ItemTrackHist.Qty := ItemTrackHist.Qty + ILE.Quantity / ILE."Qty. per Unit of Measure";
            ItemTrackHist.Modify();
        end else begin
            Clear(ItemTrackHist);
            ItemTrackHist.Init();
            //ItemTrackHist."Sales Order No." := xSalesLine."Document No.";
            //ItemTrackHist."Sales Order Line No." := xSalesLine."Line No.";
            ItemTrackHist."Lot No." := ItemEntryRelation."Lot No.";
            ItemTrackHist."Container No." := ILE."RV_Container No.";
            ItemTrackHist.Qty := ILE.Quantity / ILE."Qty. per Unit of Measure";

            ItemTrackHist."External Document No." := xSalesLine."External Document No.";
            ItemTrackHist."Sell-to Customer No." := xSalesLine."Sell-to Customer No.";
            ItemTrackHist."Item No." := xSalesLine."No.";
            ItemTrackHist.Insert();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnDeleteAfterPostingOnBeforeDeleteSalesHeader, '', false, false)]
    local procedure "Sales-Post_OnDeleteAfterPostingOnBeforeDeleteSalesHeader"(var SalesHeader: Record "Sales Header")
    var
        ItemTrackHist: Record "RV Item Tracking History Dtl.";
    begin
        /* ItemTrackHist.Reset();
        ItemTrackHist.SetRange("Sales Order No.", SalesHeader."No.");
        ItemTrackHist.DeleteAll(); */
    end;

    //FDD005 Item Tracking History Details


}
