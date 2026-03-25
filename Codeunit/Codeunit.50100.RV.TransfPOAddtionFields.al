/// <summary>
/// Codeunit RIKE RIKE Transf PO Addtion Fields (ID 50100)
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
codeunit 50100 "RV Transf PO Addtion Fields "
{
    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine, '', false, false)]
    local procedure "Purch. Rcpt. Line_OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine"(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; var NextLineNo: Integer; var Handled: Boolean)
    var
        PurOrdHeader: Record "Purchase Header";
        PurInvHeader: Record "Purchase Header";
    begin
        if PurOrdHeader.Get(PurOrdHeader."Document Type"::Order, PurchRcptLine."Order No.") then //Grab Purchase Order Header record while post the "Purchase Receipt Line" to get the additional fields value
            if PurInvHeader.Get(PurOrdHeader."Document Type"::Invoice, PurchLine."Document No.") then begin //Grab Purchase Invoice Header record to set the additional fields value
                PurInvHeader."RV ETA" := PurOrdHeader."RV ETA";
                PurInvHeader."RV ETD" := PurOrdHeader."RV ETD";
                PurInvHeader."RV Contract Month" := PurOrdHeader."RV Contract Month";
                PurInvHeader."RV Contract Year" := PurOrdHeader."RV Contract Year";
                PurInvHeader.Modify();
            end;
    end;


}
