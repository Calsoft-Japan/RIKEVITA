/// <summary>
/// Codeunit RIKE Transfer Warehouse Shipment (ID 50101)
/// FDD008 2026/03/14: New. (Liuyang)
/// </summary>
codeunit 50101 "RV TransferWarehouseShipment"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeInsertItemLedgEntry, '', false, false)]
    local procedure "Item Jnl.-Post Line_OnBeforeInsertItemLedgEntry"(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLineOrigin: Record "Item Journal Line")
    begin
        ItemLedgerEntry."RV Container No." := ItemJournalLine."RV Container No.";
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
                ItemJournalLine."RV Container No." := ResvEntry."RV Container No.";
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
                ItemJnlLine."RV Container No." := ResvEntry."RV Container No.";
        end;
    end;

}
