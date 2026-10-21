/// <summary>
/// Codeunit RV Purchase Posting Subscriber (ID 50501)
/// FDD014 2026/02/23: New. (Mike)
/// </summary>
codeunit 50501 "RV Purchase Posting Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostItemJnlLine, '', false, false)]
    local procedure "Purch.-Post_OnBeforePostItemJnlLine"(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var QtyToBeReceived: Decimal; var QtyToBeReceivedBase: Decimal; var QtyToBeInvoiced: Decimal; var QtyToBeInvoicedBase: Decimal; var ItemLedgShptEntryNo: Integer; var ItemChargeNo: Code[20]; var TrackingSpecification: Record "Tracking Specification"; CommitIsSupressed: Boolean; var IsHandled: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var Result: Integer; var WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        QCHeader: Record "RV QC Header";
    begin
        if not PurchHeader.Receive then
            exit;

        if PurchHeader."Document Type" <> PurchHeader."Document Type"::Order then
            exit;

        if QtyToBeReceived = 0 then
            exit;

        QCHeader.SetRange("QC Type", QCHeader."QC Type"::IQC);
        QCHeader.SetRange("Ref. Order Type", QCHeader."Ref. Order Type"::"Purchase Order");
        QCHeader.SetRange("Order No.", PurchHeader."No.");
        QCHeader.SetRange("Line No.", PurchLine."Line No.");
        QCHeader.SetRange("QC Status", QCHeader."QC Status"::Rejected);
        if QCHeader.FindFirst() then
            Error('Cannot post receipt for Purchase Order %1, line %2 because IQC %3 has been rejected.', PurchHeader."No.", PurchLine."Line No.", QCHeader."QC No.");
    end;
}
