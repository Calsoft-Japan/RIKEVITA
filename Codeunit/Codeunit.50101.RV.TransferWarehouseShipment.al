/// <summary>
/// Codeunit RIKE Transfer Warehouse Shipment (ID 50101)
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
codeunit 50101 "RV TransferWarehouseShipment"
{
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
        WhsShipmentLine.Reset();
        WhsShipmentLine.SetRange("Source Type", Database::"Sales Line");
        WhsShipmentLine.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
        WhsShipmentLine.SetRange("Source No.", SalesLine."Document No.");
        WhsShipmentLine.SetRange("Source Line No.", SalesLine."Line No.");
        if WhsShipmentLine.FindFirst() then begin
            ResvEntry.SetRange("Source Type", Database::"Purchase Line");
            ResvEntry.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
            ResvEntry.SetRange("Source ID", SalesLine."Document No.");
            ResvEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
            if ResvEntry.FindFirst() then
                ItemJournalLine."RV_Container No." := ResvEntry."RV_Container No.";
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnPostItemJnlLineOnBeforeItemJnlPostLineRunWithCheck, '', false, false)]
    local procedure "Purch.-Post_OnPostItemJnlLineOnBeforeItemJnlPostLineRunWithCheck"(var ItemJnlLine: Record "Item Journal Line"; var PurchaseLine: Record "Purchase Line"; DropShipOrder: Boolean; PurchaseHeader: Record "Purchase Header"; WhseReceive: Boolean; QtyToBeReceived: Decimal; QtyToBeReceivedBase: Decimal; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; var IsHandled: Boolean)
    var
        WhsShipmentLine: Record "Warehouse Shipment Line";
        ResvEntry: Record "Reservation Entry";
    begin
        WhsShipmentLine.Reset();
        WhsShipmentLine.SetRange("Source Type", Database::"Purchase Line");
        WhsShipmentLine.SetRange("Source Subtype", PurchaseLine."Document Type".AsInteger());
        WhsShipmentLine.SetRange("Source No.", PurchaseLine."Document No.");
        WhsShipmentLine.SetRange("Source Line No.", PurchaseLine."Line No.");
        if WhsShipmentLine.FindFirst() then begin
            ResvEntry.SetRange("Source Type", Database::"Purchase Line");
            ResvEntry.SetRange("Source Subtype", PurchaseLine."Document Type".AsInteger());
            ResvEntry.SetRange("Source ID", PurchaseLine."Document No.");
            ResvEntry.SetRange("Source Ref. No.", PurchaseLine."Line No.");
            if ResvEntry.FindFirst() then
                ItemJnlLine."RV_Container No." := ResvEntry."RV_Container No.";
        end;
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
        ItemTrackHist.SetRange("Sales Order No.", xSalesLine."Document No.");
        ItemTrackHist.SetRange("Sales Order Line No.", xSalesLine."Line No.");
        ItemTrackHist.SetRange("Lot No.", ItemEntryRelation."Lot No.");
        ItemTrackHist.SetRange("Container No.", ILE."RV_Container No.");
        if ItemTrackHist.FindFirst() then begin
            ItemTrackHist.Qty := ItemTrackHist.Qty + ILE.Quantity;
            ItemTrackHist.Modify();
        end else begin
            Clear(ItemTrackHist);
            ItemTrackHist.Init();
            ItemTrackHist."Sales Order No." := xSalesLine."Document No.";
            ItemTrackHist."Sales Order Line No." := xSalesLine."Line No.";
            ItemTrackHist."Lot No." := ItemEntryRelation."Lot No.";
            ItemTrackHist."Container No." := ILE."RV_Container No.";
            ItemTrackHist.Qty := ILE.Quantity;
            ItemTrackHist.Insert();
        end;
    end;

}
