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
        if not recSalesInvLine.IsEmpty then begin
            recSalesInvLine.CalcSums("RV_Freight Charge");
            CustLedgerEntry."RV_Freight Charge" := recSalesInvLine."RV_Freight Charge";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", OnCreatePostedShptLineOnBeforePostWhseJnlLine, '', false, false)]
    local procedure DoOnCreatePostedShptLineOnBeforePostWhseJnlLine(var PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        recSalesShptLine: Record "Sales Shipment Line";
    begin
        if PostedWhseShipmentLine."Posted Source Document" = PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment" then begin
            if recSalesShptLine.Get(PostedWhseShipmentLine."Posted Source No.", PostedWhseShipmentLine."Source Line No.") then begin
                recSalesShptLine."RV_Warehouse Shipment No." := WarehouseShipmentLine."No.";
                recSalesShptLine."RV_Posted Whse. Shipment No." := PostedWhseShipmentLine."No.";
                recSalesShptLine.Modify();
            end;
        end;
    end;
}