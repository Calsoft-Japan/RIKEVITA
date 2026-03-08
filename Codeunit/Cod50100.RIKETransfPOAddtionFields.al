/// <summary>
/// Codeunit RIKE RIKE Transf PO Addtion Fields (ID 50100)
/// FDD003 2026/03/08: New. (Liuyang)
/// </summary>
codeunit 50100 "RIKE Transf PO Addtion Fields "
{
    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine, '', false, false)]
    local procedure "Purch. Rcpt. Line_OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine"(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; var NextLineNo: Integer; var Handled: Boolean)
    var
        PurOrdHeader: Record "Purchase Header";
        PurInvHeader: Record "Purchase Header";
    begin
        if PurOrdHeader.Get(PurOrdHeader."Document Type"::Order, PurchRcptLine."Order No.") then //Grab Purchase Order Header record while post the "Purchase Receipt Line" to get the additional fields value
            if PurInvHeader.Get(PurOrdHeader."Document Type"::Invoice, PurchLine."Document No.") then begin //Grab Purchase Invoice Header record to set the additional fields value
                PurInvHeader.RV_ETA := PurOrdHeader.RV_ETA;
                PurInvHeader.RV_ETD := PurOrdHeader.RV_ETD;
                PurInvHeader."RV_Contract Month" := PurOrdHeader."RV_Contract Month";
                PurInvHeader."RV_Contract Year" := PurOrdHeader."RV_Contract Year";
                PurInvHeader.Modify();
            end;
    end;


}
