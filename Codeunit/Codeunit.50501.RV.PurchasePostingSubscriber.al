/// <summary>
/// Codeunit RV Purchase Posting Subscriber (ID 50501)
/// FDD039 2026/10/21: New. (Mike)
/// </summary>
codeunit 50501 "RV Purchase Posting Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostItemJnlLine, '', false, false)]
    local procedure "Purch.-Post_OnBeforePostItemJnlLine"(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var QtyToBeReceived: Decimal; var QtyToBeReceivedBase: Decimal; var QtyToBeInvoiced: Decimal; var QtyToBeInvoicedBase: Decimal; var ItemLedgShptEntryNo: Integer; var ItemChargeNo: Code[20]; var TrackingSpecification: Record "Tracking Specification"; CommitIsSupressed: Boolean; var IsHandled: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var Result: Integer; var WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        ReservationEntry: Record "Reservation Entry";
        CheckedLotNo: Code[50];
    begin
        if not PurchHeader.Receive then
            exit;

        if PurchHeader."Document Type" <> PurchHeader."Document Type"::Order then
            exit;

        if QtyToBeReceived = 0 then
            exit;

        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
        ReservationEntry.SetRange("Source Subtype", PurchLine."Document Type".AsInteger());
        ReservationEntry.SetRange("Source ID", PurchLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
        ReservationEntry.SetRange("Item No.", PurchLine."No.");
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        if ReservationEntry.FindSet() then
            repeat
                CheckedLotNo := ReservationEntry."Lot No.";
                CheckRejectedIQC(PurchHeader, PurchLine, CheckedLotNo);
            until ReservationEntry.Next() = 0
        else
            CheckRejectedIQC(PurchHeader, PurchLine, TrackingSpecification."Lot No.");
    end;

    local procedure CheckRejectedIQC(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; LotNo: Code[50])
    var
        QCHeader: Record "RV QC Header";
    begin
        if LotNo = '' then
            exit;

        QCHeader.SetRange("QC Type", QCHeader."QC Type"::IQC);
        QCHeader.SetRange("Ref. Order Type", QCHeader."Ref. Order Type"::"Purchase Order");
        QCHeader.SetRange("Order No.", PurchHeader."No.");
        QCHeader.SetRange("Line No.", PurchLine."Line No.");
        QCHeader.SetRange("Item No.", PurchLine."No.");
        QCHeader.SetRange("Lot No.", LotNo);
        QCHeader.SetRange("QC Status", QCHeader."QC Status"::Rejected);
        if QCHeader.FindFirst() then
            Error('Cannot post receipt for item %1, lot %2 on Purchase Order %3, line %4 because IQC %5 has been rejected.', PurchLine."No.", LotNo, PurchHeader."No.", PurchLine."Line No.", QCHeader."QC No.");
    end;
}
