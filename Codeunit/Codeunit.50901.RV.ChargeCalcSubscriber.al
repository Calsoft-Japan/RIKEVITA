/// <summary>
/// Codeunit RV Charge Calc. Subscriber (ID 50901)
/// FDD009 2026/05/09: New. (Shawn)
/// </summary>
codeunit 50901 "RV Charge Calc. Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeCustLedgEntryInsert, '', false, false)]
    local procedure DoOnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var NextEntryNo: Integer)
    var
        recSalesInvLine: Record "Sales Invoice Line";
    begin

        recSalesInvLine.SetRange("Document No.", CustLedgerEntry."Document No.");
        recSalesInvLine.SetRange(Type, Enum::"Sales Line Type"::Item);
        if recSalesInvLine.FindFirst() then begin
            CustLedgerEntry."RV_Freight Charge" := recSalesInvLine."RV_Freight Charge";
        end;
    end;

}