/// <summary>
/// Codeunit RV Get Receipt Lines (ID 50204)
/// FDD021 2026/05/12: New. (Bobby.ji)
/// </summary>
codeunit 50204 "RV Get Receipt Lines"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", OnAfterPurchRcptLineSetFilters, '', false, false)]
    local procedure "Purch.-Get Receipt_OnAfterPurchRcptLineSetFilters"(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchaseHeader: Record "Purchase Header")
    begin
        PurchRcptLine.SetFilter("Posting Date", '..%1', PurchaseHeader."Posting Date");
    end;

}
